
# WRFCHEM Installer

*Installer script for*  `64bit Linux`  *for*  `v4.3.3`

<br>

This is a script that installs all the libraries, software, programs, and geostatic data to run the Weather Research Forecast Model (WRFCHEM-4.3) in 64bit with KPP installed. Please share and comment. Script assumes a clean directory with no other WRF configure files in the directory.

<br>

## Preparations

**Please read the [Install Script] of your choosing before you use it.** <br>
*I have commented the code and added information on the config files.*

<br>

### Location

Please move to your home directory.

<br>

### Download

**[Download]** or **Clone** the repository.

```sh
git clone https://github.com/whatheway/WRFCHEM-4.3.3-install-script-linux-64bit.git
```

<br>

### Executable

*Before you can run the script, you* <br>
*will have to make it executable.*

```sh
sudo chmod ug+x Installer/<Script>.sh
```

```sh
sudo chmod ug+x Installer/MET.sh
```

<br>
<br>

## Installation 

You can execute an installer with:

```sh
Installer/<Script>sh
```

```sh
Installer/MET.sh
```


# WRF installation with parallel process.
## Must be installed with GNU compiler, it will not work with other compilers.

Download and install required library and data files for WRF.

Tested in Ubuntu 20.04.2 LTS

Built in 64-bit system 

Tested with current available libraries on 04/25/2022

If newer libraries exist edit script paths for changes

# Estimated Run Time ~ 80 - 150 Minutes
### Special thanks to  Youtube's meteoadriatic, GitHub user jamal919, University of Manchester Doug L, GSL Jordan S.

Hatheway, W. (2022). WRFCHEM 4.3.3 Install Script Linux 64bit (Version 4.3.3) [Computer software]


<!----------------------------------------------------------------------------->

[Download]: https://github.com/whatheway/WRFCHEM-4.3.3-install-script-linux-64bit/archive/refs/heads/main.zip

[Install Script]: Installers
