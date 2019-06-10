#!/bin/bash
# (c) Yasmeen Asali 2019

missing_segments () { 
    #parse ifo / arm args
    local ifo="$1"
    local arm="$2"
    local detector=$ifo":CAL-PCAL"$arm
    local chan=$detector"_IRIGB_DQ"
    #define start and end time
    local first_file=$(ls *$detector* | head -n 1)
    local start_time=`expr ${first_file:0:10} + 0`
    local last_file=$(ls *$detector* | tail -n 1)
    local end_time=`expr ${last_file:0:10} + 0`
    local len=`expr $end_time - $start_time` 
    local expected_files=`expr $len / 64 + 1`
    echo "Checking:" $chan
    echo "Number of files expected:" $expected_files

    #check if all the files exist, if any are missing query nds
    local num_files=$(ls *$detector* | wc -l)
    echo "Number of files found:" $num_files
    if [ $num_files -eq $expected_files ]; then
        echo "All files found"
    elif [ $num_files -lt $expected_files ]; then
        echo "Missing" `expr $expected_files - $num_files` "files"
        for filename in $(ls *$detector*)
        do
            local time=`expr ${filename:0:10} + 0`
            local next_time=`expr $time + 64`
            local next_filename=$next_time".0_64_"$detector"_IRIGB_DQ.txt"
            local stop_time=`expr $end_time + 64`
            if [[ ! -e $next_filename && $time -ne $end_time ]]; then
#		until [ -e $next_filename ]; do
                echo "Missing Segment at "$next_time". Fetching data now..." 
                nds_query -n nds.ligo.caltech.edu -s $next_time -d 64 -v "$chan" | ~/IRIGB/get_vals | ~/IRIGB/geco_irig_decode.py | ~/IRIGB/continuous_irig_check.py -t $next_time -i $ifo -a $arm  >/dev/null 2>&1 #this automatically deletes the output
#		    let next_filename=`expr $next_time + 64`".0_64_"$detector"_IRIGB_DQ.txt"
#		done
            fi
        done
        echo "Checking feteched data..."
        for filename in $(ls *$detector*)
        do 
            local time=`expr ${filename:0:10} + 0`
            local next_time=`expr $time + 64`
            local next_filename=$next_time".0_64_"$detector"_IRIGB_DQ.txt"
            local stop_time=`expr $end_time + 64`
            if [[ ! -e $next_filename && $time -ne $end_time ]]; then
                echo "One segment still missing, making empty file at" $next_time
                local empty_file=$next_time".0_64_"$detector"_IRIGB_DQ.txt"
		local declare nan=( $(for i in {1..64}; do echo "nan"; done) )
		printf '%s\n' "${nan[@]}" > $empty_file 
            fi
        done
    else
        echo "More files found than expected"
    fi
}
    
missing_segments "H1" "X"
missing_segments "H1" "Y"
missing_segments "L1" "X"
