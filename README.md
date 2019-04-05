# Checking the IRIG-B Timestamp for an event
*(c) Yasmeen Asali, April 2019*

## Dependencies 

The `irig_check.sh` script calls on three other scripts, all attached. These are:
1. `get_vals`
2. `geco_irig_decode.py`
3. `convert_to_gps.py`

The python scripts require a number of packages, many of which are likely already installed such as `gwpy`. Notably, the conversion script also requires gpstime. This package can be installed on the following operating systems in the following ways: 
1. Mac OS using MacPorts
    - run `sudo port install py36-gpstime`
2. Debian 
    - gpstime can be installed with the cds-workstation umbrella package. Installation directions can be found [here](https://git.ligo.org/cds-packaging/docs/wikis/home)
3. LIGO Computing Cluster
    - if running on the cluster, you can install the package for your user using the following commands: 
```
mkdir -p ~/dev
cd ~/dev
git clone https://git.ligo.org/cds/gpstime.git
cd gpstime
pip install --user --editable .
```
Once you have all the neccessary scripts and packages you are ready to run the checks.

## Running the scripts 

To run the event IRIG-B checking scripts simply run the following in terminal:
```
export EVNTTIME=1237606078 #change this to reflect the relevant time
./irig_check.sh
```
  
This script checks the IRIG-B Timestamp for +/- 10 seconds around the event time for the following four channels:
```
H1:CAL-PCALX_IRIGB_DQ		
H1:CAL-PCALY_IRIGB_DQ
L1:CAL-PCALX_IRIGB_DQ		
L1:CAL-PCALY_IRIGB_DQ
```

The output will print directly to terminal. If you would like to save the output, simply run the script as follows:
```
./irig_check.sh > output.txt #for your choice of filename
``` 

