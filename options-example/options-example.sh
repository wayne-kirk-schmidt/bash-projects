#!/bin/bash
###
### SCRIPTNAME [ options ] a script to generate vmtesttool config files
###
###	-h | --help		display this message and exit
###	-v | --verbose		run the script verbosely ( for debugging purposes ) 
###
### The script is run from: BASEDIR
### The script will cache files in the following directories:
###
###	+ BASEDIR/../cfg -- language definition files
###	+ BASEDIR/../var -- log files
###

display_help () {

  scriptname=$( basename $0 ) 
  startdir=$( ls -Ld $PWD ) 
  cat $0 | egrep -i '^###' | sed  's/^###//g' | \
  sed "s/SCRIPTNAME/$scriptname/g" | sed "s#BASEDIR#$startdir#g"
  exit 0

}

initialize_variables () {

  ${verboseflag}

  base=$( ls -Ld $PWD )			&& export base
  logs="/tmp"				&& export logs
  
  bindir=$(cd $base/..; echo $PWD/bin )	&& export bindir
  cfgdir=$(cd $base/..; echo $PWD/cfg )	&& export cfgdir
  vardir=$(cd $logs/..; echo $base/var)	&& export vardir
  datestamp=$(date '+%Y%m%d')           && export datestamp
  timestamp=$(date '+%H%M%S')           && export timestamp

}

initialize_environment () {

  ${verboseflag}
  echo "mkdir -p $cfgdir $bindir $vardir"

}

main_logic () { 

  initialize_variables
  initialize_environment
}
  
while getopts "hvo:" options;
do
  case "${options}" in
    h)
      display_help
      exit 0
      ;;
    v)
      verboseflag='set -x'
      export verboseflag
      ;;
    *)
      display_help
      exit 0
      ;;
  esac
done
shift $((OPTIND-1))

main_logic
