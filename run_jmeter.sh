#!/bin/bash
#usage: nohup sh run_jmeter.sh --jmxFile ./jmeter-ux2.3/ux2.3_mailpabcaltask_v1.0.jmx --output ux2.3_mailpabcaltask_3000 --propertyFile ./jmeter-ux2.3/test.properties --resdir /root/ux2.3-result/ux2.3-mailpabcaltask-result/ux2.3-mailpabcaltask-3000-result > test.log 2>&1 &

#usage: nohup sh run_jmeter.sh --jmxFile ./jmeter-ux2.3/ux2.3_mailcategory_v1.0.jmx --output ux2.3_mailcategory_1000 --propertyFile ./jmeter-ux2.3/test.properties --resdir /root/ux2.3-result/ux2.3-mailcategory-result/ux2.3-mailcategory-1000-result > test.log 2>&1 &

#usage: nohup sh run_jmeter.sh --jmxFile ./jmeter-ux2.3/ux2.3_attachmentView_1.0.jmx --output ux2.3_attachmentView_1000 --propertyFile ./jmeter-ux2.3/test.properties --resdir /root/ux2.3-result/ux2.3-attachmentView-result/ux2.3-attachmentView-1000-result > test.log 2>&1 &

#usage: nohup sh run_jmeter.sh --jmxFile ./jmeter-ux2.3/ux2.3_sortbysubject_v1.0.jmx --output ux2.3_sortbysubject_3000 --propertyFile ./jmeter-ux2.3/test.properties --resdir /root/ux2.3-result/ux2.3-sortbysubject-result/ux2.3-sortbysubject-3000-result > test.log 2>&1 &
##set -x

usage()
{
    echo "------------------------------------------------------------------"
    echo "Jmeter Remote Test Usage:"
    echo " ${0}"
    echo "            --jmxFile <path to the .jmx file>"
    echo "            --output <results name>]"
    echo "            [ --propertyFile <path to the property file>]"
    echo "            [ --resdir <directory of the output files>]"
    echo "------------------------------------------------------------------"
    exit 0
}

if [ $# -lt 4 ]; then
    usage
fi

export JMETER_HOME=/root/apache-jmeter-3.3
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.144-0.b01.el7_4.x86_64

opts="-n -r"
resultDir=`pwd`

while [ $# -gt 0 ]; do
    if [ "${1}" = "--jmxFile" ]; then
        TestScript=${2}
        if [ ! -f $TestScript ]; then
            echo "Error --> Cannot find the jmx file $TestScript ;"
            exit 1
        fi
        opts="${opts} -t $TestScript"
        shift
    elif [ "${1}" = "--output" ]; then
        Output=${2}
        shift
    elif [ "${1}" = "--propertyFile" ]; then
        PropertyFile=${2}
        if [ ! -f $PropertyFile ]; then
            echo "Error --> Cannot find the property file $PropertyFile ;"
            exit 2
        fi
	    opts="${opts}  -G${PropertyFile}"
        shift
    elif [ "${1}" = "--resdir" ]; then
        resultDir=${2}
	shift
    else
        echo "ERROR -- Option ${1} invalid"
        usage
    fi
    shift
done

#if [ ! -f ${resultDir} ]; then
#    mkdir -p ${resultDir}
#fi

rm -rf ${resultDir}
mkdir -p ${resultDir}

rootDir="/root/ux2.3-test-data"
resultDirMonitor="${resultDir}/monitor-result"
resultDirJmeter="${resultDir}/jmeter-result"
# clear previous data
rm -rf ${resultDirMonitor} ${resultDirJmeter}
mkdir -p ${resultDirMonitor} ${resultDirJmeter}

ResultName=`date +%Y%m%d%H%M%S`_${Output}
logFile="${resultDirJmeter}/${ResultName}.log"
jtlFile="${resultDirJmeter}/${ResultName}.jtl"
csvFile="${resultDirJmeter}/${ResultName}.csv"
pngFile="${resultDirJmeter}/${ResultName}.png"
opts="${opts} -l $jtlFile -j $logFile"

tmpFile="${resultDirJmeter}/tmp$$"
htmlFile="${resultDirJmeter}/${ResultName}.html"

# msgFile="test$$.msg"
# cpuOutput="cpu.png"
# memOutput="mem.png"



## Run the Jmeter tests
run_jmeter()
{
    # run_jmeter.sh
    # /root/apache-jmeter-3.3/bin/jmeter -n -r -Gtest.properties -t ux2.3_mx9.2_mailpabcaltask_v1.0.jmx -l /root/ux2.3-test-data/jmeter-ux2.3-result/ux2.3_mx9.2_mailpabcaltask_v1.0.jtl -j /root/ux2.3-test-data/jmeter-ux2.3-result/ux2.3_mx9.2_mailpabcaltask_v1.0.log
    echo "Task: Running Jemter test --> Start"
    cmd="${JMETER_HOME}/bin/jmeter ${opts}"
    echo "Issuing: $cmd"

    $cmd

    echo "Task: Running Jemter test --> done"

    sync
}

generate_jmeter_dashBoard()
{
    echo "Task: Generating Jmeter dashBoard --> Start"

    if ![ -f `pwd`/$jtlFile ]; then
        echo "Error: No jtl file found"
        exit 3 
    fi

    # result.csv/jtl -> dashBoard
    cmd="${JMETER_HOME}/bin/jmeter -g $jtlFile -o ${resultDirJmeter}/DashBoard"
    echo "Generate Jmeter DashBoard: $cmd"

    $cmd

    echo "Task: Generating Jmeter dashBoard --> Done"
}


## Generate Aggregate Report
generate_jmeter_report()
{
    echo "Task: Generating Jmeter report --> Start"

    if ![ -f `pwd`/$jtlFile ]; then
        echo "Error: No jtl file found"
        exit 3 
    fi

    cmd="${JMETER_HOME}/bin/JMeterPluginsCMD.sh --generate-csv $csvFile --input-jtl $jtlFile --plugin-type AggregateReport"
    echo "Generate CSV File: ${cmd}"
    $cmd

#    cmd="${JMETER_HOME}/bin/JMeterPluginsCMD.sh --generate-png $pngFile --input-jtl $jtlFile --plugin-type AggregateReport --width 800 --height 600"
#    echo "Generate PNG File: ${cmd}"
#    $cmd

    echo "Task: Generating Aggregate report --> done"
}

start_monitoring()
{ 
    echo "Task: monitoring --> Start"
    ## start monitoring
    sh ${rootDir}/monitor/monitor_yz start
}

stop_monitoring()
{
    echo "Task: monitoring --> Stop"
    ## stop monitoring
	echo "./monitor/monitor_yz stop $resultDirMonitor"
    sh ${rootDir}/monitor/monitor_yz stop $resultDirMonitor
}

process_monitoring()
{
    echo "Task: process monitoring result--> Start"
    ## process monitoring result
    sh ${rootDir}/monitor/process_monitor_result.sh $resultDirMonitor
    echo "Task: process monitoring result--> done"
}

sync_time()
{
    echo "Task: timeSync --> Start"
    ## start monitoring
    sh ${rootDir}/monitor/timeSync
    echo "Task: timeSync --> End"
}

parse_jmeter_report()
{
    if [ ! -f $csvFile ]; then
        echo "Error: No csv file found"
        exit 4
    fi
    echo "Task: parse jmeter report --> Start"
    sh ${rootDir}/jmeter-ux2.3/parse_jmeter_report.sh $csvFile $htmlFile $tmpFile
    echo "Task: parse jmeter report --> End"
}

upload_logs()
{
   ssh root@10.17.56.94 "cd /root/mx95 ; python nagiosCollector.py $Output"
   sleep 5
   ssh root@10.16.251.223 "cd /opt/PAC/mx95_uploadlogs ; ./fetch_serverlog_mx92.sh $Output"
   sleep 5
   ssh root@10.16.251.223 "cd /opt/PAC/mx95_uploadlogs ; ./fetch_OS_nagios_log.sh $Output"
   sleep 5
   ssh root@10.16.251.223 "cp /*.jtl /repo/mx9.5/linux/testData/benchTests/$Output/jmeter-test-results-csv/ ; rm -rf /*.jtl"
   
}   

echo "Start Running! $(date)"

sync_time

start_monitoring

sleep 10
# run jmeter
run_jmeter

stop_monitoring

# process monitor result
process_monitoring

generate_jmeter_report
parse_jmeter_report


#generate_jmeter_dashBoard

echo "Finished: All tasks done! $(date)"
