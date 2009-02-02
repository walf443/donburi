#!/bin/sh

from=$1
to=$2
now=$3

if [ ! $now ]
then
  now=`date "+%H"`;
fi

if [ $from -lt $to ] && [ $from -le $now ] && [ $now -lt $to ]
then
  exit 0;
elif [ $from -eq $to ] && [ $from -eq $now ]
then
  exit 0;
elif [ $to -lt $from ] && ( [ $from -le $now ] || [ $now -lt $to ] )
then
  exit 0;
else
  exit 1;
fi

