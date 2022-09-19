#!/bin/bash

color_r=(50000 150000 150000 250000 100000)
color_g=(70000 150000 70000  50000  1)
color_b=(90000 100000 150000 10000  250000)

function_rgbinit()
{
for i in 0 1 2
do
    echo 0 > /sys/class/pwm/pwmchip${i}/export
    echo 256000 > /sys/class/pwm/pwmchip${i}/pwm0/period
    echo normal  > /sys/class/pwm/pwmchip${i}/pwm0/polarity
    echo 0 > /sys/class/pwm/pwmchip${i}/pwm0/duty_cycle
    echo 1 > /sys/class/pwm/pwmchip${i}/pwm0/enable
done
}

path="/sys/class/pwm/pwmchip0/pwm0"
if [ ! -d "$path" ]; then
    function_rgbinit
fi

function_blink()
{
while true ;
do
    for ((i=0;i<${#color_r[*]};i++)) 
        do 
        echo $i 
        echo ${color_r[$i]}  > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
        echo ${color_g[$i]} > /sys/class/pwm/pwmchip1/pwm0/duty_cycle
        echo ${color_b[$i]} > /sys/class/pwm/pwmchip2/pwm0/duty_cycle
        sleep 1
  done
done
}

rgb_breathe(){
while true ;
do
for ((x=0;x<3;x++))
do
    for ((i=1;i<255;i++))
    do
    j=$(expr $i \* 1000)
    echo ${j} > /sys/class/pwm/pwmchip${x}/pwm0/duty_cycle
    #echo $j
    sleep 0.0002
    done
    sleep 0.5
    for ((i=255;i>1;i--))
    do
    j=$(expr $i \* 1000)
    echo ${j} > /sys/class/pwm/pwmchip${x}/pwm0/duty_cycle
    #echo $j
    sleep 0.0001
    done
done
done
}

case "$1" in

blink)
    function_blink
    ;;
rgb_breathe)
    rgb_breathe
    ;;
*)
        echo "Usage: $0 {blink|rgb_breathe}"
        exit 1
esac

exit 0
