#!/bin/bash -x
cd /Upload/OrdinaryFile/provider
file=`find ./ -type f  -name *.png`
for f  in $file;
	do   convert $f ${f%.*}.jpg 
done 
