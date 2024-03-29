#!/bin/bash

SCREENDIR="$HOME/.sshscreen"

source /etc/profile

if [ ! -d "$SCREENDIR" ]; then
  mkdir -p $SCREENDIR
  chmod 700 $SCREENDIR
fi

listScreens() {
 SCREENDIR=$SCREENDIR screen -list
}

createScreen() {
    if [ -z $1 ]
    then
        echo "Please write Session name"
        return
    fi
    if SCREENDIR=$SCREENDIR screen -ls | grep -o "[0-9]*\.$1" >/dev/null 2>&1 ;
    then
        echo "Session name \"$1\" is already used"
        return
    fi
    SCREENDIR=$SCREENDIR screen -e^Bb -S $1
}

closeScreen() {
    if [ -z $1 ]
    then
        echo "Please write Session name"
        return
    fi
    SCREENDIR=$SCREENDIR screen -X -S $1 quit
}

reatachScreen(){
    if [ -z $1 ]
    then
        echo "Please write Session name"
        return
    fi
    SCREENDIR=$SCREENDIR screen -e^Bb -rd $1
}

mirrorScreen(){
    if [ -z $1 ]
    then
        echo "Please write Session name"
        return
    fi
   SCREENDIR=$SCREENDIR screen -e^Bb -x $1
}

deattachScreen() {
    if [ -z $1 ]
    then
        echo "Please write Session name"
        return
    fi
    SCREENDIR=$SCREENDIR screen -d $1
}

helpFunc="
    Here is avaible commands
        (li)st
            List all screens for $USER
        (cr)eate Screen-Name
            Create New screen
        (cl)ose  Screen-Name
            Close Screen
        (re)atach Screen-Name
            Reattach to screen
        (mi)rror Screen-Name
            Attach screen second or third times for multiple usage
        (de)atach  Screen-Name
            Deatach Screen
        (ex)it
            Close this connection
"

    helpFunc() {
        if [ -z "$funcoutput" ];
        then
        echo -e "$helpFunc"
        else
        echo -e "$helpFunc"
        echo -e "$funcoutput"
        fi
    }

countdown() {
    trap exit INT EXIT
tput sc
for i in {30..0}
do 
    if ! kill -0 $1 > /dev/null 2>&1; then
        exit
    fi
    tput sc
    tput cup 3 5; echo "Time left $i "
    tput rc
    if [ $i = "0" ]; then
        clear
        echo "No command is given."
        echo "Quiting ...."
        kill -9 $1 >/dev/null 2>&1
        exit
    fi
    sleep 1
done
}

while true
do

tput clear
tput cup 2 5   
tput setaf 6   
countdown $$ &  
countdown_pid=$!

echo -e "SSH  Screen Select:\tWelcome to Server $HOSTNAME"
tput sgr0
helpFunc

echo
if [ -z "$1" ]
then
    read -e  -p 'What do you want ? »' noargstart
    tput rc
    noargstartarray=($(echo $noargstart | tr " " "\n"))
    set ${noargstartarray[@]}
else
    exitonexit="yes"
fi
    kill  $countdown_pid >/dev/null 2>&1
    wait $countdown_pid 2>/dev/null
    case $1 in
        list|li)
            shift 1
            funcoutput=`listScreens`
        ;;
        create|cr)
            shift 1
            funcoutput=`createScreen $@`
        ;;
        close|cl)
            shift 1
            funcoutput=`closeScreen $@`
        ;;
        reatach|re)
            shift 1
            funcoutput=`reatachScreen $@`
        ;;
        mirror|mi)
            shift 1
            funcoutput=`mirrorScreen $@`
        ;;
        deattach|de)
            shift 1
            funcoutput=`deattachScreen $@`
        ;;
        exit|ex)
            clear
            exit
        ;;
        *)
            funcoutput="ERR. Command not found"
        ;;
    esac

if [ ! -z "$exitonexit" ]
then
        echo -e "$funcoutput"
        break
fi
set --

done
