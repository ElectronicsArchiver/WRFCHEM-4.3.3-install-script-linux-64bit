#!/bin/bash

## WRFCHEM installation with parallel process.
# Download and install required library and data files for WRFCHEM/KPP.
# Tested in Ubuntu 20.04.4. LTS
# Built in 64-bit system
# Tested with current available libraries on 04/25/2022
# If newer libraries exist edit script paths for changes
#Estimated Run Time ~ 80 - 150 Minutes with 10mb/s downloadspeed.
#Special thanks to  Youtube's meteoadriatic and GitHub user jamal919
#University of Manchester Doug L, GSL Jordan S.
#############################basic package managment############################
sudo apt update                                                                                                   
sudo apt upgrade                                                                                                    
sudo apt install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git ncview ncl-ncarg build-essential unzip mlocate byacc flex



##############################Directory Listing############################
export HOME=`cd;pwd`
mkdir $HOME/WRFCHEM
cd $HOME/WRFCHEM
mkdir Downloads
mkdir Libs
mkdir Libs/grib2
mkdir Libs/NETCDF
mkdir Libs/MPICH

##############################Downloading Libraries############################
cd Downloads
wget -c https://github.com/madler/zlib/archive/refs/tags/v1.2.11.tar.gz
wget -c https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_1.tar.gz
wget -c https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.8.1.tar.gz
wget -c https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.4.tar.gz
wget -c https://github.com/pmodels/mpich/releases/download/v4.0.2/mpich-4.0.2.tar.gz
wget -c https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz
wget -c https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
wget -c https://sourceforge.net/projects/opengrads/files/grads2/2.2.1.oga.1/Linux%20%2864%20Bits%29/opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz






#############################Compilers############################
export DIR=$HOME/WRFCHEM/Libs
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran

#############################zlib############################
##### Utilizing Zlib 1.2.11 instead of Zlib 1.2.12  #########
##### due to bugs in new zlib package that needs to #########
##### be fixed.  Will update once patched           #########
cd $HOME/WRFCHEM/Downloads
tar -xvzf v1.2.11.tar.gz
cd zlib-1.2.11/
./configure --prefix=$DIR/grib2
make
make install
make check


#############################libpng############################
cd $HOME/WRFCHEM/Downloads
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
tar -xvzf libpng-1.6.37.tar.gz
cd libpng-1.6.37/
./configure --prefix=$DIR/grib2
make
make install
make check
#############################JasPer############################
cd $HOME/WRFCHEM/Downloads
unzip jasper-1.900.1.zip
cd jasper-1.900.1/
autoreconf -i
./configure --prefix=$DIR/grib2
make
make install

export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include




#############################hdf5 library for netcdf4 functionality############################
cd $HOME/WRFCHEM/Downloads
tar -xvzf hdf5-1_13_1.tar.gz
cd hdf5-hdf5-1_13_1
./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran
make 
make install
make check

export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH

##############################Install NETCDF C Library############################
cd $HOME/WRFCHEM/Downloads
tar -xzvf v4.8.1.tar.gz
cd netcdf-c-4.8.1/
export CPPFLAGS=-I$DIR/grib2/include 
export LDFLAGS=-L$DIR/grib2/lib
./configure --prefix=$DIR/NETCDF --disable-dap
make 
make install
make check

export PATH=$DIR/NETCDF/bin:$PATH
export NETCDF=$DIR/NETCDF


##############################NetCDF fortran library############################
cd $HOME/WRFCHEM/Downloads
tar -xvzf v4.5.4.tar.gz
cd netcdf-fortran-4.5.4/
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/NETCDF/include 
export LDFLAGS=-L$DIR/NETCDF/lib
./configure --prefix=$DIR/NETCDF --disable-shared
make 
make install
make check

##############################MPICH############################
cd $HOME/WRFCHEM/Downloads
tar -xvzf mpich-4.0.2.tar.gz
cd mpich-4.0.2/
./configure --prefix=$DIR/MPICH --with-device=ch3
make
make install
make check


export PATH=$DIR/MPICH/bin:$PATH

###############################NCEPlibs#####################################
#The libraries are built and installed with
# ./make_ncep_libs.sh -s MACHINE -c COMPILER -d NCEPLIBS_DIR -o OPENMP [-m mpi] [-a APPLICATION]
#It is recommended to install the NCEPlibs into their own directory, which must be created before running the installer. Further information on the command line arguments can be obtained with
# ./make_ncep_libs.sh -h

#If iand error occurs go to https://github.com/NCAR/NCEPlibs/pull/16/files make adjustment and re-run ./make_ncep_libs.sh
############################################################################


cd $HOME/WRFCHEM/Downloads
git clone https://github.com/NCAR/NCEPlibs.git
cd NCEPlibs
mkdir $DIR/nceplibs

export JASPER_INC=$DIR/grib2/include
export PNG_INC=$DIR/grib2/include
export NETCDF=$DIR/NETCDF
./make_ncep_libs.sh -s linux -c gnu -d $DIR/nceplibs -o 0 -m 1 -a upp





################################UPPv4.1######################################
#Previous verison of UPP
#Current verison of UPP requires extra libraries not included in this script
#IF you choose to use UPP9.0 or later you will need to edit this script and download additional programs
#Option 8 gfortran compiler with distributed memory
#############################################################################
cd $HOME/WRFCHEM
git clone -b dtc_post_v4.1.0 --recurse-submodules https://github.com/NOAA-EMC/EMC_post UPPV4.1 
cd UPPV4.1
mkdir postprd
export NCEPLIBS_DIR=$DIR/nceplibs
export NETCDF=$DIR/NETCDF

./configure  #Option 8 gfortran compiler with distributed memory
./compile
cd $HOME/WRFCHEM/UPPV4.1/scripts
chmod +x run_unipost


######################## ARWpost V3.1  ############################
## ARWpost
##Configure #3
###################################################################
cd $HOME/WRFCHEM/Downloads
wget -c http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
tar -xvzf ARWpost_V3.tar.gz -C $HOME/WRFCHEM
cd $HOME/WRFCHEM/ARWpost
./clean
sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $HOME/WRFCHEM/ARWpost/src/Makefile
export NETCDF=$DIR/NETCDF
./configure  
sed -i -e 's/-C -P/-P/g' $HOME/WRFCHEM/ARWpost/configure.arwp
./compile


################################ OpenGrADS ##################################
#Verison 2.2.1 64bit of Linux
#############################################################################
cd $HOME/WRFCHEM/Downloads
tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $HOME/WRFCHEM
cd $HOME/WRFCHEM
mv $HOME/WRFCHEM/opengrads-2.2.1.oga.1  $HOME/WRFCHEM/GrADS
cd GrADS/Contents
wget -c ftp://ftp.cpc.ncep.noaa.gov/wd51we/g2ctl/g2ctl
chmod +x g2ctl
wget -c https://sourceforge.net/projects/opengrads/files/wgrib2/0.1.9.4/wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
tar -xzvf wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
cd wgrib2-v0.1.9.4/bin
mv wgrib2 $HOME/WRFCHEM/GrADS/Contents
cd $HOME/WRFCHEM/GrADS/Contents
rm wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
rm -r wgrib2-v0.1.9.4


export PATH=$HOME/WRFCHEM/GrADS/Contents:$PATH






############################ WRFCHEM 4.3.3 #################################
## WRF v4.3.3
## Downloaded from git tagged releases
# option 34, option 1 for gfortran and distributed memory w/basic nesting
# If the script comes back asking to locate a file (libfl.a)
# Use locate command to find file. in a new terminal and then copy that location
#locate *name of file* 
#Optimization set to 0 due to buffer overflow dump
#sed -i -e 's/="-O"/="-O0/' configure_kpp
########################################################################
#Setting up WRF-CHEM/KPP
cd $HOME/WRFCHEM/Downloads

ulimit -s unlimited
export WRF_EM_CORE=1
export WRF_NMM_CORE=0  
export WRF_CHEM=1
export WRF_KPP=1 
export YACC='/usr/bin/yacc -d' 
export FLEX=/usr/bin/flex
export FLEX_LIB_DIR=/usr/lib/x86_64-linux-gnu/ 
export KPP_HOME=$HOME/WRFCHEM/WRF-4.3.3/chem/KPP/kpp/kpp-2.1
export WRF_SRC_ROOT_DIR=$HOME/WRFCHEM/WRF-4.3.3
export PATH=$KPP_HOME/bin:$PATH
export SED=/usr/bin/sed
export WRFIO_NCD_LARGE_FILE_SUPPORT=1

#Downloading WRF code

cd $HOME/WRFCHEM/Downloads
wget -c https://github.com/wrf-model/WRF/archive/v4.3.3.tar.gz -O WRF-4.3.3.tar.gz
tar -xvzf WRF-4.3.3.tar.gz -C $HOME/WRFCHEM
cd $HOME/WRFCHEM/WRF-4.3.3

cd chem/KPP
sed -i -e 's/="-O"/="-O0"/' configure_kpp
cd -

./configure # option 34, option 1 for gfortran and distributed memory w/basic nesting
./compile em_real 
export WRF_DIR=$HOME/WRFCHEM/WRF-4.3.3

############################WPSV4.3.1#####################################
## WPS v4.3.1
## Downloaded from git tagged releases
#Option 3 for gfortran and distributed memory 
########################################################################

cd $HOME/WRFCHEM/Downloads
wget -c https://github.com/wrf-model/WPS/archive/refs/tags/v4.3.1.tar.gz -O WPS-4.3.1.tar.gz
tar -xvzf WPS-4.3.1.tar.gz -C $HOME/WRFCHEM
cd $HOME/WRFCHEM/WPS-4.3.1
./configure #Option 3 for gfortran and distributed memory 
./compile




######################## WPS Domain Setup Tools ########################
## DomainWizard
cd $HOME/WRFCHEM/Downloads
wget -c http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
mkdir $HOME/WRFCHEM/WRFDomainWizard
unzip WRFDomainWizard.zip -d $HOME/WRFCHEM/WRFDomainWizard
chmod +x $HOME/WRFCHEM/WRFDomainWizard/run_DomainWizard


######################## WPF Portal Setup Tools ########################
## WRFPortal
cd $HOME/WRFCHEM/Downloads
wget -c https://esrl.noaa.gov/gsd/wrfportal/portal/wrf-portal.zip
mkdir $HOME/WRFCHEM/WRFPortal
unzip wrf-portal.zip -d $HOME/WRFCHEM/WRFPortal
chmod +x $HOME/WRFCHEM/WRFPortal/runWRFPortal

######################## DTC's MET & METplus ###########################
## See script for details

$HOME/WRFCHEM-4.3.3-install-script-linux-64bit/MET_self_install_script_Linux_64bit.sh


######################## Static Geography Data inc/ Optional ####################
# http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
# Double check if Irrigation.tar.gz extracted into WPS_GEOG folder
# IF it didn't right click on the .tar.gz file and select 'extract here'
#################################################################################
cd $HOME/WRFCHEM/Downloads
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
mkdir $HOME/WRFCHEM/GEOG
tar -xvzf geog_high_res_mandatory.tar.gz -C $HOME/WRFCHEM/GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
tar -xvzf geog_thompson28_chem.tar.gz -C $HOME/WRFCHEM/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
tar -xvzf geog_noahmp.tar.gz -C $HOME/WRFCHEM/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
tar -xvzf irrigation.tar.gz -C $HOME/WRFCHEM/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
tar -xvzf geog_px.tar.gz -C $HOME/WRFCHEM/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
tar -xvzf geog_urban.tar.gz -C $HOME/WRFCHEM/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
tar -xvzf geog_ssib.tar.gz -C $HOME/WRFCHEM/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
tar -xvf lake_depth.tar.bz2 -C $HOME/WRFCHEM/GEOG/WPS_GEOG
                                                 


## export PATH and LD_LIBRARY_PATH
echo "export PATH=$DIR/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH" >> ~/.bashrc



#####################################BASH Script Finished##############################
echo "Congratulations! You've successfully installed all required files to run the Weather Research Forecast Model Chemistry verison 4.3."
echo "Thank you for using this script" 
