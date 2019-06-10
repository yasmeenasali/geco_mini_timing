#!/usr/bin/env python
# (c) Madox McGrae 2018, Yasmeen Asali 2019
'''
Script for converting IRIG-B decoded outputs to GPSTIME

gpstime.LEAPDATA.data queries current number of leapseconds between UTC and TAI, then converts to the number of leapseconds between UTC and GPS.

The 19 second offset between TAI and GPS will never change so it is hardcoded.

'''
import sys
from gwpy.time import to_gps
import gpstime

timestamps =[]
def stdin_to_gps():
    for line in sys.stdin:
        time = line[10:19]
        mon = line[4:8]
        day = line[8:11]
        year = line[20:24]
        datetime_obj = mon + day + year + time
        leap = gpstime.LEAPDATA.data[-1][1] - 19 
        gps = to_gps(str(datetime_obj)).gpsSeconds - leap 
        print(gps)
        #timestamps.append(int(round(time.gps)))

stdin_to_gps()
