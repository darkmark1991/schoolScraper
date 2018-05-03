#!/bin/bash

outputFile="output.csv"
touch $outputFile

header="\"N\",\"სკოლის დასახელება\",\"რეგიონი\",\"რაიონი\",\"დირექტორი (სახელი, გვარი)\",\"მისამართი\",\"ელ. ფოსტა\","
echo $header>$outputFile

counter=0
found=0

for counter in {0..10000}; do

    result=`wget -qO- "http://catalog.edu.ge/index.php?module=school_info&page=detals&school_code=${counter}"`

    name=`echo $result | grep -Po '<h4 class="right">\K[^<]*'`

    if [ "$name" != "" ]; then

        name="\"${name//\"/\"\"}\""

        info=`echo $result | grep -Po '<td class="admin_table_td([1-2]*) schoon_right">\K[^<]*' | head -n5 | sed 's/.*/"&",/'`

        output=`echo "${found},${name},${info}"`
        echo $output>>$outputFile

        echo -ne "Schools found: $found\r"
        let found=found+1
    fi
done
