# Timing Checks for IRIG-B Timestamp and DuoTone Delays
*(c) Yasmeen Asali, April 2019*

## Plotting DuoTone delay histograms

Plotting histograms of the DuoTone delay times requires the `duotone_delay.py` script. To run the checks simply execute the following in terminal:
```
. ~/detchar/opt/gwpysoft/bin/activate #run this if executing commands in the cluster to load a working version of gwpy
./duotone_delay.py -s -i "H1" -t 1237606078
deactivate #only if you activate the environment
```

You can change `"H1"` to `"L1"` to generate the plots for LHO and LLO respectively. The plots are created in the working directory. You can also run `./duotone_delay.py -h` to see more information.  

## Checking the IRIG-B Timestamp for an event

### Dependencies 

The `irig_check.sh` script calls on three other scripts. These are:
1. `get_vals`
2. `geco_irig_decode.py`
3. `convert_to_gps.py`

You can find all of these scripts in the zipped file `irig_event_checking_scripts.tar.gz`. To unzip this file, run: 
```
tar -zxvf irig_event_checking_scripts.tar.gz
```

The python scripts require a number of packages, many of which are likely already installed such as `gwpy`. Notably, the conversion script also requires `gpstime`. This package can be installed on the following operating systems in the following ways: 
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

### Running the scripts 

To run the event IRIG-B checking scripts simply run the following in terminal:
```
kinit
export EVNTTIME=1237606078
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

