# WRFCHEM-4.3-install-script-linux-64bit
This is a script that installs all the libraries, software, programs, and geostatic data to run the Weather Research Forecast Model (WRFCHEM-4.3) in 64bit with KPP installed. Please share and comment. Script assumes a clean directory with no other WRF configure files in the directory.

# Installation 
(Make sure to download folder into your Home Directory):

> git clone https://github.com/whatheway/WRFCHEM-4.3-install-script-linux-64bit.git

> chmod +x WRF_CHEMKPP_INSTALL_64BIT.sh

> chmod +x MET_self_install_script_Linux_64bit.sh

> chmod +x METplus_self_install_script_Linux_64bit.sh

> ./WRF_CHEMKPP_INSTALL_64BIT.sh

# Please make sure to read the WRF_ARW_INSTALL.sh script before installing.  
I have provided comments on what the script is doing and information on configuration files.


# WRF installation with parallel process.
## Must be installed with GNU compiler, it will not work with other compilers.

Download and install required library and data files for WRF.

Tested in Ubuntu 20.04.2 LTS

Built in 64-bit system 

Tested with current available libraries on 05/25/2021

If newer libraries exist edit script paths for changes

# Estimated Run Time ~ 80 - 120 Minutes
### Special thanks to  Youtube's meteoadriatic, GitHub user jamal919, University of Manchester Doug L, GSL Jordan S.
