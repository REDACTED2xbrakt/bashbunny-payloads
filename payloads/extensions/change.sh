##########################################################################
# Extension created by [REDACTED] and creator of the bash_bunny.sh file  #
##########################################################################
# Run Bash Bunny script specified in a payload.txt                       #
##########################################################################
# Bastardized from bash_bunny.sh    :-)                                  #
##########################################################################

#!/bin/bash

function CHANGE(){

  #user must denote beginning and end with "
  local payload_directory=$udisk_folder $1

  if [ -f $payload_directory ]; then
    # New $PATH is temporarily valid for all .sh scripts
    #     in folder $udisk_folder/payloads/$switch/.
    # Note the order of searching path
    PATH=$udisk_folder/payloads/$switch/:$udisk_folder/payloads/library/:$payload_directory:$PATH
    echo --- PATH = $PATH

    # make a copy of payload file to /tmp/ folder
    cp $payload_directory /tmp/payload.txt
    payload_file="/tmp/payload.txt"
    # remove dos format trailing Carriage Return \r
    sed -i 's/\r//g' $payload_directory

    lang_line=$(cat $payload_directory | grep 'Q SET_LANGUAGE')
    if [ "x$lang_line" = "x" ]; then
    lang_line=$(cat $payload_directory | grep 'QUACK SET_LANGUAGE')
    fi
    DUCKY_LANG=$(echo $lang_line | awk {'print $3'} | awk '{print tolower($0)}')
    if [ "x$DUCKY_LANG" = "x" ]; then
      DUCKY_LANG="us"
    fi
    echo DUCKY_LANG = $DUCKY_LANG
    export DUCKY_LANG

    # run install.sh in the directory specified by CHANGE if it exists
    local install_file=$payload_directory /install.sh
    if [ -f $install_file ]; then
    # make a copy of install.sh file to /tmp/ folder
    cp $install_file /tmp/install.sh
    install_file="/tmp/install.sh"
    # remove dos format trailing Carriage Return \r
    sed -i 's/\r//g' $install_file

    /bin/bash -c "$install_file"
    local status=$?
    echo --- Exit status of install.sh is $status
    if [ $status -eq 0 ]; then
      mv $payload_directory /install.sh \
      $payload_directory /install.sh.INSTALLED
      sync
    fi
  fi

  # Run payload.txt
  /bin/bash -c "$payload_directory"
        
  #execute

}

export -f change