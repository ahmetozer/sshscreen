#!/bin/bash

SCREENDIR="$HOME/.sshscreen"
if [ ! -d "$SCREENDIR" ]; then
  mkdir -p $SCREENDIR
  chmod 700 $SCREENDIR
fi

listScreens() {
 screen -list
}

createScreen() {
    if [ -z $1 ]
    then
        echo "Please write Socket Name"
        return
    fi
    screen -e^Bb -S $1
    unset screenName
}

closeScreen() {
    if [ -z $1 ]
    then
        echo "Please write Socket Name"
        return
    fi
    screen -X -S $1 quit
}

reatachScreen(){
    if [ -z $1 ]
    then
        echo "Please write Socket Name"
        return
    fi
    screen -e^Bb -rd $1
}

mirrorScreen(){
    if [ -z $1 ]
    then
        echo "Please write Socket Name"
        return
    fi
   screen -e^Bb -x $1
}

deattachScreen() {
    if [ -z $1 ]
    then
        echo "Please write Socket Name"
        return
    fi
    screen -d $1
}

helpFunc() {
    echo "Here is avaible commands
    (li)st 
        List all screens for $USER
    (cr)eate Screen-Name
        Create New screen
    (cl)ose  Screen-Name
        Close Screen
    (re)atach Screen-Name
        Re attach to screen
    (mi)rror Screen-Name
        Attach screen second or third times for multiple usage
    (de)attach  Screen-Name
        Deattach Screen
    "
}

while true
do
    helpFunc
    read -p 'What do you want ? » ' -e noargstart
    noargstartarray=($(echo $noargstart | tr " " "\n"))
    set ${noargstartarray[@]}
    case $1 in
        list|li)
            shift 1
            listScreens
        ;;
        create|cr)
            shift 1
            createScreen $@
        ;;
        close|cl)
            shift 1
            closeScreen $@
        ;;
        reatach|re)
            shift 1
            reatachScreen $@
        ;;
        mirror|mi)
            shift 1
            mirrorScreen $@
        ;;
        deattach|de)
            shift 1
            deattachScreen $@
        ;;
        *)
            echo "ERR. Command not found"
        ;;
    esac


done
