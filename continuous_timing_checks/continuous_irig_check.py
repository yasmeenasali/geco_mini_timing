#!/usr/bin/env python3 
# (c) Madox McGrae 2018, Yasmeen Asali 2019

DESC=''' Scripts for continuously checking IRIG-B Timestamp
'''
EPILOG=''
IFOs = ['H1','L1']
ARMS = ['X','Y']
dur = 64 #how much time between checks

#imports after if statement, quits immediately on -h flags to skip slow imports

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='DESC', epilog=EPILOG)
    parser.add_argument('-i', '--ifo', choices=IFOs, help=('Which IFO to check'))
    parser.add_argument('-a', '--arm', choices=ARMS, help=('which arm to check'))
    parser.add_argument('-t', '--gpstime', type=float, help=('GPS time of check'))
    args = parser.parse_args()

import sys
import smtplib
from gwpy.time import to_gps
import gpstime
import numpy as np

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
        timestamps.append(gps)

#stdin_to_gps()
#print(len(timestamps), dur)

#n is number of gps timestamps being checked

'''
def initial_size_check(GPSTIME, IFO, ARM, dur):
    size = len(timestamps)
    if size != dur:
        #send email notifying timing error
        s = smtplib.SMTP('smtp.gmail.com', 587)
        s.starttls()
        s.login("gecotiming", "Einstein1915")
        text = "IRIG-B output list is {} number of elements off from expected. See {}_{}_{}:CAL-PCAL{}_IRIGB_DQ.txt for raw data.".format(size, GPSTIME, dur, IFO, ARM)
        subject = "Initial size check error for {} {} arm.".format(IFO, ARM) 
        message = "Subject: {}\n\n{}".format(subject, text) 
        s.sendmail("gecotiming","gecotiming@gmail.com", message)
        s.quit()
'''
            
def check_irig_timestamp(GPSTIME, IFO, ARM, dur):
    start = int(GPSTIME)
    control_arr = np.arange(start, (start+dur), 1)
    zero_arr = control_arr - timestamps
    for i in zero_arr:
        if i != 0:
            #send email notifying timing error
            s = smtplib.SMTP('smtp.gmail.com', 587)
            s.starttls()
            s.login("gecotiming", "Einstein1915")
            text = "Nonzero difference between IRIG-B Timestamp and expected GPSTIME. IRIG-B Timestamp is {} seconds off from expected. See {}_{}_{}:CAL-PCAL{}_IRIGB_DQ.txt for details of error.".format(i, GPSTIME, dur, IFO, ARM)
            subject = "Unexpected Timestamp for {} {} arm".format(IFO, ARM) 
            message = "Subject: {}\n\n{}".format(subject, text) 
            s.sendmail("gecotiming","gecotiming@gmail.com", message)
            s.quit()
    #print(control_arr, timestamps, zero_arr)
    f = open("{}_{}_{}:CAL-PCAL{}_IRIGB_DQ.txt".format(GPSTIME, dur, IFO, ARM), "w+")
    f.writelines("%s\n" % times for times in timestamps)
    f.close()

if __name__ == '__main__':
    stdin_to_gps()
    #initial_size_check(args.gpstime, args.ifo, args.arm, dur)
    if args.ifo is None or args.gpstime is None or args.arm is None:
        print('ERROR: Must provide both IFO, arm, and gpstime.\n')
        print(DESC)
        exit(1)
    check_irig_timestamp(args.gpstime, args.ifo, args.arm, dur)

