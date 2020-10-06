#!/bin/bash

lpstat -s | awk '{ if ($1 == "device" && /DYMO_LabelWriter_400/) {print substr($3,0,length($3)-1)}} ' | while read printer
do
    echo "Deleting Printer: " $printer
    lpadmin -x $printer
done