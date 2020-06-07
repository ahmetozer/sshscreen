# sshscreen

The main goal of this project is restore ssh sessions while new connection.  
In daily life, developers are develop program or design systems at remote servers.
If the projects is big enough to require more than one session, time between two sessions your ssh connection might be drop due to connection issue or closing PC.

To prevent this I use screen to restore my shell sessions but in screen I also use screen again in screens.  
This script will be organize your SSH login screens easier ans separate Login screens and in projects screens.

## Features

Most of the features comes from screen capabilities.

- List previous sessions
- Create screen Sessions
- Reattach screen
- Mirror screen (You can use Session at same time different location)
- Detach screen
- Timeout. If the TCP socket is already open but you are drop the session, this will be close your ssh connection.

## Install

This script is requires must server side installation and client side setup for if you don't want to write a command every login.

### Server Side

```bash
#Run these commands with Root privileges. If you are not have Root privileges you can achieve with sudo su command.
curl https://raw.githubusercontent.com/ahmetozer/sshscreen/master/sshscreen.sh -O /usr/bin/sshscreen
chmod +x /usr/bin/sshscreen
```

### Client Side

- Open your .ssh/config file.
- add below lines to your server configuration.

```bash
    RemoteCommand sshscreen
    RequestTTY yes
```

Ex.

```bash
    Host amsterdam
    User root
    Port 22
    Hostname 127.0.0.1
    ServerAliveInterval 60
    RemoteCommand sshscreen
    RequestTTY yes
```

If you don't want to add every your ssh connection. You can add below command to end of the config file.

```bash
Host *
    RemoteCommand sshscreen
    RequestTTY yes
```

## Demo

[![Demo](https://img.youtube.com/vi/J3ed1sLQHus/0.jpg)](https://www.youtube.com/watch?v=J3ed1sLQHus)
