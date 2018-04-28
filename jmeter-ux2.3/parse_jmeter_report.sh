csvFile=$1
htmlFile=$2
tmpFile=$3

COLOUR="#b3e3e1"

next_color()
{
	if [ "$COLOUR" = "#ead6e4" ]; then
		COLOUR="#e9dff7"
	else
		COLOUR="#ead6e4"
	fi
}

nice_number()
{
	num=$1
	if [[ "${num:0:1}" = "." ]]; then
		num="0"${num}
	fi
	echo "$num"
}


parse_jmeter_report()
{
    echo "Task: Generating html report --> Start"
    ## Generate html report
    echo "<HTML><BODY>" > $htmlFile

    title_color="#cf9bc0"

    echo "<Table width=70%>" >> $htmlFile

    ## Add the title row
    echo "<TR>" >> $htmlFile
    echo "<TD bgcolor=$title_color><B>Label</TD>" >> $htmlFile
    echo "<TD bgcolor=$title_color><B>#Samples</TD>" >> $htmlFile
    echo "<TD bgcolor=$title_color><B>Average</TD>" >> $htmlFile
    ##echo "<TD bgcolor=$title_color><B>90% Line</TD>" >> $htmlFile
    echo "<TD bgcolor=$title_color><B>Min</TD>" >> $htmlFile
    echo "<TD bgcolor=$title_color><B>Max</TD>" >> $htmlFile
    echo "<TD bgcolor=$title_color><B>Error</TD>" >> $htmlFile
    echo "<TD bgcolor=$title_color><B>Throughput</TD>" >> $htmlFile
    echo "</TR>" >> $htmlFile


    ## Add data rows
    sed '1d;$d' $csvFile > $tmpFile

    while read line
    do

	next_color
	label=`echo $line | cut -f 1 -d ','`
	samples=`echo $line | cut -f 2 -d ','`
	avg=`echo $line | cut -f 3 -d ','`
##	line90=`echo $line | cut -f 5 -d ','`
	min=`echo $line | cut -f 8 -d ','`
	max=`echo $line | cut -f 9 -d ','`
	error=`echo $line | cut -f 10 -d ','`
	throughput=`echo $line | cut -f 11 -d ','`
	throughput=$(nice_number $throughput)
	echo "<TR bgcolor=$COLOUR>"  >> $htmlFile
	echo "<TD>$label</TD><TD>$samples</TD><TD>$avg</TD><TD>$min</TD><TD>$max</TD><TD>$error</TD><TD>$throughput</TD></TR>" >> $htmlFile
    done < $tmpFile

    ## Add last line -- the total Line
    line=$(tail -1 $csvFile)
    samples=`echo $line | cut -f 2 -d ','`
    avg=`echo $line | cut -f 3 -d ','`
##    line90=`echo $line | cut -f 5 -d ','`
    min=`echo $line | cut -f 8 -d ','`
    max=`echo $line | cut -f 9 -d ','`
    error=`echo $line | cut -f 10 -d ','`
    throughput=`echo $line | cut -f 11 -d ','`
    throughput=$(nice_number $throughput)
    echo "<TR bgcolor=#bcfbf7>"  >> $htmlFile
    echo "<TD><B>TOTAL</TD><TD><B>$samples</TD><TD><B>$avg</TD><TD><B>$min</TD><TD><B>$max</TD><TD><B>$error</TD><TD><B>$throughput</TD></TR>" >> $htmlFile

    echo "</TABLE>" >> $htmlFile
    echo "</BODY></HTML>" >> $htmlFile


    echo "Task: Generating html report --> done"

}


parse_jmeter_report
