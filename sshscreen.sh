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

helpFunc="
    Here is avaible commands
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

tput clear      # clear the screen
tput cup 2 5   # Move cursor to screen location X,Y (top left is 0,0)
tput setaf 6    # Set a foreground colour using ANSI escape
countdown $$ &
countdown_pid=$!

echo "SSH  Screen Select"
tput sgr0
helpFunc

echo
read -e  -p 'What do you want ? »' noargstart
tput rc
    kill $countdown_pid >/dev/null 2>&1
    noargstartarray=($(echo $noargstart | tr " " "\n"))
    set ${noargstartarray[@]}
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


done
