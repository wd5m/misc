I provide the \*SPACE\* EchoLink and IRLP 0100 node for live audio from NASA space missions. See [space.rfnet.link](http://space.rfnet.link/). This audio is also linked to Allstar node 516221. Normally, all connections to these audio feed nodes are listen-only, with each connected EchoLink and IRLP node muted so as not to cause interference with others.  Allstar does not provide a simple method to mute "incoming" node connnections, and so transmissions from Allstar nodes will be heard by other connected nodes.

To minimize potential interference from incoming Allstar connections, I have enabled an Allstar [event](https://wiki.allstarlink.org/wiki/Event_Management) monitor to disconnect nodes that transmit. The event monitor is configured in the Allstar /etc/asterisk/rpt.conf file as follows.

```
[events516221]  ; Event stanza for node 516221 in the rpt.conf file
/root/mykeyed1.sh 516221 = s|t|RPT_TXKEYED
```

`/root/mykeyed1.sh 516221` is the script to be executed, passing the argument value 516221, when `RPT_TXKEYED` is TRUE (1).

`s` is the shell action directive to execute a shell command, in this case the mykeyed1.sh script

`t` is the event action type for going true (1).

`RPT_TXKEYED` is an Asterisk channel variable that goes TRUE (1) when any node is transmitting.

The script `mykeyed1.sh` executes asterisk commands and processes to evaulate whether any further action is required, such as disconnecting a node that is transmitting. 

Note: The `RPT_TXKEYED` variable is either active (1) or inactive (0). If the event fires when this variable goes active, and one or more other nodes key up while the event is active, this event does NOT fire again. So the event script must take this possiblity into account and monitor for nodes that key while the `RPT_TXKEYED` variable is active.
