#!/usr/bin/env bash 
# (c) Yasmeen Asali, Madox McGrae, Ana Lam 2019

export GPSTIME=1242046790
export NUM=64

while true
nds_query -n nds.ligo.caltech.edu -s $GPSTIME  -d $NUM   -v "H1:CAL-PCALX_IRIGB_DQ"  | ./get_vals | ./geco_irig_decode.py | ./continuous_irig_check.py -i "H1" -a "X" -t $GPSTIME
nds_query -n nds.ligo.caltech.edu -s $GPSTIME  -d $NUM   -v "H1:CAL-PCALY_IRIGB_DQ"  | ./get_vals | ./geco_irig_decode.py | ./continuous_irig_check.py -i "H1" -a "Y" -t $GPSTIME
nds_query -n nds.ligo.caltech.edu -s $GPSTIME  -d $NUM   -v "L1:CAL-PCALX_IRIGB_DQ"  | ./get_vals | ./geco_irig_decode.py | ./continuous_irig_check.py -i "L1" -a "X" -t $GPSTIME
nds_query -n nds.ligo.caltech.edu -s $GPSTIME  -d $NUM   -v "L1:CAL-PCALY_IRIGB_DQ"  | ./get_vals | ./geco_irig_decode.py | ./continuous_irig_check.py -i "L1" -a "Y" -t $GPSTIME
export GPSTIME=$(( $GPSTIME+$NUM ))
do sleep $NUM
done
