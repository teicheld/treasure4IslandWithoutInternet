#!/bin/bash

t_start=$(date +%s)
rx_start=$(cat /sys/class/net/wlp2s0/statistics/rx_bytes)
sleep $1
t_end=$(date +%s)
rx_end=$(cat /sys/class/net/wlp2s0/statistics/rx_bytes)

speed="$(( (($rx_end-$rx_start)/($t_end - $t_start))/3000 ))"
if [ "$speed" -gt 28 ]
then
	play -n synth 1 pluck $speed
else
	play -n synth 1 brownnoise
fi
