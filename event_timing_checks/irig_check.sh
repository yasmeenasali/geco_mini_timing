#!/usr/bin/env bash
# (c) Yasmeen Asali 2019

#IRIG-B Check for Individual Events, +/- 10 seconds
#Outputs two columns: GPSTIME and IRIG-B Timestamp for 4 IRIG-B channels
#DEPENDENCIES: 
# - must have gpstime package installed
# - must "export EVNTTIME=" before running

SUPEREVENT="$1"

EVNTTIME_FULL="$2"
EVNTTIME=${EVNTTIME_FULL:0:-7}
GPSTIME=$(( $EVNTTIME - 10 ))

#Check each of the four IRIG-B Channels
#HX
output_gps_1=$(nds_query -n nds.ligo.caltech.edu -s $GPSTIME -d 20 -v "H1:CAL-PCALX_IRIGB_DQ" | ./get_vals | ./geco_irig_decode.py | ./convert_to_gps.py)
#HY
output_gps_2=$(nds_query -n nds.ligo.caltech.edu -s $GPSTIME -d 20 -v "H1:CAL-PCALY_IRIGB_DQ" | ./get_vals | ./geco_irig_decode.py | ./convert_to_gps.py)
#LX
output_gps_3=$(nds_query -n nds.ligo.caltech.edu -s $GPSTIME -d 20 -v "L1:CAL-PCALX_IRIGB_DQ" | ./get_vals | ./geco_irig_decode.py | ./convert_to_gps.py)
#LY
output_gps_4=$(nds_query -n nds.ligo.caltech.edu -s $GPSTIME -d 20 -v "L1:CAL-PCALY_IRIGB_DQ" | ./get_vals | ./geco_irig_decode.py | ./convert_to_gps.py)

#Generate time column  
max=$(( $GPSTIME + 20 ))
input_gps=$(while [ $GPSTIME -lt $max ]; do echo $GPSTIME; GPSTIME=$(( $GPSTIME + 1 )); done)
label=$'\n\n\n\n\n\n\n\n\n\nEvent Time'

#Print out values
echo "Timing Checks for "$SUPEREVENT" at GPS time "$EVNTTIME_FULL
echo
#HX
echo "Checking IRIG-B Timestamp for H1:CAL-PCALX_IRIGB_DQ"
paste <(printf %-10s "GPSTIME") <(printf %-10s "IRIG-B Timestamp")
paste <(printf %-10s "$input_gps") <(printf %-10s "$output_gps_1") <(printf %-10s "$label") 
#HY
echo "Checking IRIG-B Timestamp for H1:CAL-PCALY_IRIGB_DQ"
paste <(printf %-10s "GPSTIME") <(printf %-10s "IRIG-B Timestamp")
paste <(printf %-10s "$input_gps") <(printf %-10s "$output_gps_2") <(printf %-10s "$label") 
#LX
echo "Checking IRIG-B Timestamp for L1:CAL-PCALX_IRIGB_DQ"
paste <(printf %-10s "GPSTIME") <(printf %-10s "IRIG-B Timestamp")
paste <(printf %-10s "$input_gps") <(printf %-10s "$output_gps_3") <(printf %-10s "$label") 
#LY
echo "Checking IRIG-B Timestamp for L1:CAL-PCALY_IRIGB_DQ"
paste <(printf %-10s "GPSTIME") <(printf %-10s "IRIG-B Timestamp")
paste <(printf %-10s "$input_gps") <(printf %-10s "$output_gps_4") <(printf %-10s "$label") 

