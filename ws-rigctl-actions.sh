#!/bin/bash
# Logic for arguments sent to the script
while getopts s:a:d:t:p: flag
do
    case "${flag}" in
        s) server=${OPTARG};;
        a) action=${OPTARG};;
        d) argument=${OPTARG};;
		t) test=${OPTARG};;
        p) port=${OPTARG};;
    esac
done
echo server

# If server is null or empty use home IP as default
if [ -z $server ]; then
	server="127.0.0.1"
fi
# If port is unset use rigtctld default port
if [ -z $port ]; then
	port="4532"
fi

#If test is set up dummy radio otherwise use net rigctl radio model
# --- If test is not null then read it, check the argument, and set to dummy radio.  If not set it to net rigctl radio
if [ -n $test ]; then
	case $test in
		"1" | "y" | "Y" | "on" | "ON" | "On")
			model="1"
			echo "Dummy Radio Activated"
			;;
		*) # Any other option with -t gets net radio
			model="2"
	esac
else
	model="2"
fi
# Check for rigctl command code and if found execute.  Return information is stdout. To add a command add a switch line here. Commands with similiar structures could be "x" | "y" ored on lines but to allow for argument filter below they are broken out.
case $action in
  "T")
	case $argument in
	  "0" | "1") # If it is valid on or off use this command. Otherwise no action
	    echo rigctl -m $model -r $server:$port $action $argument
	    #echo "PTT_OFF"
             ;;
	    *)
		echo "Invalid PTT Set command option"
	esac
    ;;
  "t") # 
    	rigctl -m $model -r $server:$port $action
    ;;
  "m") # Multiple patterns can be separated by |
        rigctl -m $model -r $server:$port $action
    ;;
  "M") # Multiple patterns can be separated by |
        case $argument in
	  "USB" | "usb" | "LSB" | "lsb" | "FM" | "fm")
		# the ${argument^^} changes the string to upper case. as rigctld only takes uppercase but this allows this script to take lowercase
		rigctl -m $model -r $server:$port $action ${argument^^} -1
	  ;;
	  *)
		echo "Invalid mode option. No changes sent"
           ;;
	esac
	;;
  "f")
	rigctl -m $model -r $server:$port $action
	;;
  "F")
	# This GIANT IF statment just confirms the frequency to set is in a US ham band
	if (( \
	$argument >= 1800000 && $argument <=2000000 || \
	$argument >= 3500000 && $argument <=4000000 || \
	$argument >= 7000000 && $argument <=7300000 || \
	$argument >= 10100000 && $argument <=10150000 || \
	$argument >= 14000000 && $argument <=14350000 || \
	$argument >= 18068000 && $argument <=18168000 || \
	$argument >= 21000000 && $argument <=21450000 || \
	$argument >= 24890000 && $argument <=24990000 || \
	$argument >= 28000000 && $argument <=29700000 || \
	$argument >= 50000000 && $argument <=54000000 || \
	$argument >= 144000000 && $argument <=148000000 || \
	$argument >= 222000000 && $argument <=225000000 || \
	$argument >= 420000000 && $argument <=450000000 || \
	$argument == 5330500 || \
	$argument == 5346500 || \
	$argument == 5357000 || \
	$argument == 5371500 || \
	$argument == 5403500
	)); then
		rigctl -m $model -r $server:$port $action $argument
		echo "VALID"
	else
		echo "Invalid ham band frequency. No changes sent"
	fi
	;;

  *) # Default case for any other match
    echo "Invalid hamlib action argument"
    ;;
esac

