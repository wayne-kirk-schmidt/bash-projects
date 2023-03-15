#!/bin/bash
###
### SCRIPTNAME [ options ] a script to generate vmtesttool config files
###
###	-h | --help		display this message and exit
###	-v | --verbose		run the script verbosely ( for debugging purposes ) 
###	-o | --output 		save the output of the execution into <outputfile>
###	-c | --config		use a config file with <key>=<value> pairs to set variables
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
  vardir=$(cd $logs/..; echo $PWD/var )	&& export vardir
  datestamp=$(date '+%Y%m%d')		&& export datestamp
  timestamp=$(date '+%H%M%S')		&& export timestamp

}

initialize_environment () {

  ${verboseflag}
  echo "mkdir -p $cfgdir $bindir $vardir"

  # These should be all of the languages we'd ever want to test, sorted by ISO
  # this is a 3 character code, that we'll use for our client generation
  # the file is small, so we can afford to pull this down on a regular basis

  targeturl="https://raw.githubusercontent.com/datasets/language-codes/master/data/language-codes-full.csv"
  export targeturl

  fulllist="$vardir/language-codes-full.csv"	&& export fulllist
  langlist="$vardir/language-codes-list.csv"	&& export langlist

  # get only the name, and the 3 letter code based on a list. 
  # we populate grepping on the 1st and/or 2nd field reutning a list

  curl -s $targeturl > $fulllist
  cat $fulllist | awk -F, '{printf("%s,%s\n"), $1, $4}' > $langlist

}

initialize_language_set () {

  ${verboseflag}
  languages=$( \
    egrep -i '\"(korean|chinese|english|japanese)\"' $langlist | egrep -vi alpha  | \
    awk -F, '{print$1}' | sed 's/"//g' \
  ) 
  export languages

}

main_logic () { 

  initialize_variables
  initialize_environment
  initialize_language_set
  print "languagelist: ${languages}"
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
