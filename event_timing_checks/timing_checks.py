#!/usr/bin/env python
from ligo.gracedb.rest import GraceDb, HTTPError
import argparse
import subprocess
import duotone_delay_O3B_version

DESC="""A script for checking the IRIG-B timestamps and plotting DuoTone delay histograms 
at H1 and L1 around a superevent time. Requires the following scripts: duotone_delay_03B_version.py, 
irig_checl.sh, get_vals, geco_irig_decode.py, and convert_to_gps.py
"""

#terminal colors
_GREEN = '\033[92m'
_RED = '\033[91m'
_CLEAR = '\033[0m'

parser = argparse.ArgumentParser(description=DESC)
parser.add_argument("-l", "--list", nargs='+', help=('List of Superevent IDs'))
parser.add_argument('-s', '--superevent', type=str, help=('Superevent ID'))
parser.add_argument('-t', '--gpstime', help=('GPS time of the event with nanoseconds'))
args = parser.parse_args()

def get_time(superevent):
    client = GraceDb()
    response = client.superevent(superevent)
    data = response.json()
    time = float(data['t_0'])
    return time

def irig_check(superevent, time):
    irig_file = '{0}_irig_check.txt'.format(superevent)
    irig_call='./irig_check.sh {0} {1} > {2}'.format(superevent, time, irig_file)
    subprocess.call([irig_call], shell=True)

def single_event_check(superevent, time):
    print(_RED + "Timing Checks for {} at {}".format(superevent, time) + _CLEAR)
    print(_GREEN + 'Starting IRIG-B Check' + _CLEAR)
    irig_check(superevent, time)
    print(_GREEN + 'IRIG-B Check Finished' + _CLEAR)
    print(_GREEN + 'Starting DuoTone Check at LHO' + _CLEAR)
    duotone_delay_O3B_version.commissioningFrameDuotoneStat('H1', time, superevent)
    print(_GREEN + 'LHO DuoTone Check Finished' + _CLEAR)
    print(_GREEN + 'Starting DuoTone Check at LLO' + _CLEAR)
    duotone_delay_O3B_version.commissioningFrameDuotoneStat('L1', time, superevent)
    print(_GREEN + 'LLO DuoTone Check Finished' + _CLEAR)
    print(_RED +  "All Timing Checks for {} Finished".format(superevent) + _CLEAR)

if __name__ == '__main__':
    if args.list is not None:
        for superevent in args.list:
            time = get_time(superevent)
            single_event_check(superevent, time)
    elif args.superevent is not None:
        if args.gpstime is not None:
            single_event_check(args.superevent, args.gpstime)
        else:
            time = get_time(args.superevent)
            single_event_check(args.superevent, time)
    else:
        print('ERROR: must give either multiple or single superevent ID')
        exit(1)

    
    
