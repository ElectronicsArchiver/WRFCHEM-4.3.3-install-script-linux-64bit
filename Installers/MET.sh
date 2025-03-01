#!/bin/bash
export HOME=`cd;pwd`

#Basic Package Management for Model Evaluation Tools (MET)

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install python-dev python3-dev emacs flex bison libpixman-1-dev libjpeg-dev pkg-config libpng-dev unzip python3.8 python3.8-dev python3-pip pipenv gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git ncview ncl-ncarg libncurses5 libncurses6 mlocate


#Directory Listings
mkdir $HOME/WRFCHEM/MET-10.1.1
mkdir $HOME/WRFCHEM/MET-10.1.1/Downloads
mkdir $HOME/WRFCHEM/METplus-4.1.1
mkdir $HOME/WRFCHEM/METplus-4.1.1/Downloads



#Downloading MET and untarring files
cd $HOME/WRFCHEM/MET-10.1.1/Downloads
wget https://raw.githubusercontent.com/dtcenter/MET/develop/scripts/installation/compile_MET_all.sh
wget https://dtcenter.ucar.edu/dfiles/code/METplus/MET/installation/tar_files.tgz
wget https://github.com/dtcenter/MET/releases/download/v10.1.1/met-10.1.1.20220419.tar.gz 

cp compile_MET_all.sh $HOME/WRFCHEM/MET-10.1.1
tar -xvzf tar_files.tgz -C $HOME/WRFCHEM/MET-10.1.1
cp met-10.1.1.20220419.tar.gz $HOME/WRFCHEM/MET-10.1.1/tar_files
cd $HOME/WRFCHEM/MET-10.1.1


# Installation of Model Evaluation Tools
cd $HOME/WRFCHEM/MET-10.1.1
sed -i 's/-fno-second-underscore -fallow-argument-mismatch/-fno-second-underscore -Wno-argument-mismatch/g' compile_MET_all.sh


export FC=/usr/bin/gfortran
export F77=/usr/bin/gfortran
export F90=/usr/bin/gfortran
export gcc_version=$(gcc -dumpfullversion)
export TEST_BASE=$HOME/WRFCHEM/MET-10.0.0                       
export COMPILER=gnu_$gcc_version                 
export MET_SUBDIR=${TEST_BASE}                   
export MET_TARBALL=met-10.0.0.20210510.tar.gz    
export USE_MODULES=FALSE                          
export MET_PYTHON=/usr                        
export MET_PYTHON_CC=-I${MET_PYTHON}/include/python3.8  
export MET_PYTHON_LD=-L${MET_PYTHON}/lib/python3.8/config-3.8-x86_64-linux-gnu\ -L${MET_PYTHON}/lib\ -lpython3.8\ -lcrypt\ -lpthread\ -ldl\ -lutil\ -lm   
export SET_D64BIT=FALSE  

chmod +x compile_MET_all.sh
./compile_MET_all.sh 

export PATH=$HOME/WRFCHEM/MET-10.1.1/bin:$PATH            #Add MET executables to path

cd 
$HOME/WRFCHEM-4.3.3-install-script-linux-64bit//METplus_self_install_script_Linux_64bit.sh



