#!/bin/sh

###
#       © 2014 Andre Leifeld - jabbaa.com
#       Author: Andre Leifeld
#       Website: http://wwww.jabbaaa.com
# 
#       Bower, NPM & interactive LESS & Coffee unix build-script
###

LESS_IN=../assets/styles/src
LESS_OUT=../assets/styles/lib

COFFEE_IN=../assets/scripts/src
COFFEE_OUT=../assets/scripts/lib

BOWER_ROOT=../

NPM=`command -v npm`
BOWER=`command -v bower`
LESS=`command -v lessc`
COFFEE=`command -v coffee`

BASEDIR=$(dirname $0)
cd $BASEDIR

SCRIPT_PATH=`pwd -P`

#
# Check if NPM is installed
#

if [ "$NPM" == "" ]
  then
    echo "No npm found"
    echo "Please install Node.js"
    echo "On Mac with homebrew run 'brew install node'"
  else

    #
    # Check if Bower is installed
    #

    if [ "$BOWER" == "" ]
      then
        echo "No bower found"
        echo "Please run 'npm install -g bower'"
      else

        #
        # Check if LESS is installed
        #

        if [ "$LESS" == "" ]
          then
            echo "No lessc found"
            echo "Please run 'npm install -g less'"
        fi

        #
        # Check if Coffee is installed
        #

        if [ "$COFFEE" == "" ]
          then
            echo "No coffee found"
            echo "Please run 'npm install -g coffee-script'"
        fi


        #
        # Install bower dependencies
        #

        echo "Installing bower dependencies ... "
        cd $BOWER_ROOT
        bower install
        cd $SCRIPT_PATH
        echo "Bower dependencies installed."

        #
        # Creating folder structure if not exists
        #

        if [ ! -d "$COFFEE_OUT" ]
        then
          echo "No coffee source folder found"
          echo "Created folder: $COFFEE_OUT"
          mkdir -p $COFFEE_OUT
        fi

        if [ ! -d "$COFFEE_IN" ]
        then
          echo "No coffee library folder found"
          echo "Created folder: $COFFEE_IN"
          mkdir -p $COFFEE_IN
        fi

        if [ ! -d "$LESS_OUT" ]
        then
          echo "No LESS source folder found"
          echo "Created folder: $LESS_OUT"
          mkdir -p $LESS_OUT
        fi

        if [ ! -d "$LESS_IN" ]
        then
          echo "No LESS library folder found"
          echo "Created folder: $LESS_IN"
          mkdir -p $LESS_OUT
        fi

        #
        # Start build-loop if LESS or Coffee installed
        # if not - abort script
        #

        if [ "$COFFEE" != "" ] || [ "$LESS" != "" ]
          then

            echo "Watching for new coffee- and/or less-files..."

            while true ;
            do
              if [ "$COFFEE" != "" ]
                then
                  for f in $COFFEE_IN/*
                  do
                    if [ -f $f ]
                      then

                        #
                        # Compile coffee files in source folder
                        #

                        FILE=`basename "$f"`
                        DIFF=$((`date +%s`-`stat -L -f %m $COFFEE_IN/$FILE`))
                        if [ $DIFF -lt 3 ]
                          then
                            coffee $1 --compile --output $COFFEE_OUT $COFFEE_IN
                            break
                        fi
                    fi
                done
              fi

              if [ "$LESS" != "" ]
                then

                  #
                  # Get less files in source folder
                  #

                  for f in $LESS_IN/*
                  do
                    if [ -f $f ]
                      then

                        #
                        # Compile less files
                        #

                        FILE=`basename "$f"`
                        DIFF=$((`date +%s`-`stat -L -f %m $LESS_IN/$FILE`))
                        if [ $DIFF -lt 3 ]
                          then
                            CSSFILE=`echo "$FILE" | sed -e "s/less/css/g"`
                            lessc $2 "$LESS_IN/$FILE" > "$LESS_OUT/$CSSFILE"
                        fi
                    fi
                  done
              fi
              sleep 2s
            done
        fi
    fi
fi
echo "Aborted"