#!/bin/bash

FILES=dotFiles/*
NO_ARGS=0 
E_OPTERROR=85

argument_error() {
    echo "Usage: `basename $0` options (-e <environment>)"
    exit $E_OPTERROR          
}

make_link() {
	if [ -e $1 ]; then
        if [ -L $2 ]; then
            echo "link $2 exists. unlinking before create."
            unlink $2
        elif [ -f $2 ]; then
            echo "$2 exists. please remove before running script."
            exit 1
        fi
        
        echo "creating link from $1 to $2"
        ln -s $1 $2
    else
        echo "$1 does not exist"
    fi
}

. environment_funcs.sh


if [ $# -eq "$NO_ARGS" ]; then
    argument_error
fi  

while getopts ":e:" Option
do
    case $Option in 
        e) process_environment $OPTARG ;;
        *) argument_error ;;
    esac
done

shift $(($OPTIND - 1))

for f in $FILES
do
	FILENAME=`pwd`/$f
	LINK_LOCATION=$HOME/${f/dotFiles\/\_/\.}

    make_link $FILENAME $LINK_LOCATION
done
