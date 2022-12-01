I provide the *SPACE* EchoLink and IRLP 0100 node for live audio from NASA space missions. See [space.rfnet.link](http://space.rfnet.link/). This audio is also linked to Allstar node 516221. Normally, all connections to these audio feed nodes are listen-only, with each connected EchoLink and IRLP node muted so as not to cause interference with others.  Allstar does not provide a simple method to mute "incoming" node connnections, and so transmissions from Allstar nodes will be heard by other connected nodes.

To minimize potential interference from incoming Allstar connections, I have enabled an Allstar [event](https://wiki.allstarlink.org/wiki/Event_Management) monitor to disconnect nodes that transmit. The event monitor is configured in the Allstar /etc/asterisk/rpt.conf file as follows.

```
[events516221]  ; Event stanza for node 516221 in the rpt.conf file
MYKEYED1 = v|e|!${RPT_ALINKS} =~ "\",1100[TRC]K\"" & ${RPT_ALINKS} =~ "\",.+[TRC]K\""
/root/mykeyed1.sh 516221 = s|t|MYKEYED1
```

`MYKEYED1` is the variable name for my event.  

`v` is the event action for setting a variable.

`e` is the event type to evaluating a statement.

`!$[RPT_ALINKS} =~ "\",1100\[TRC\]K\""` is a statement that is TRUE when node 1100, the private SPACE audio feed, is NOT transmitting. This prevents the event from executing the script when SPACE audio is active.

`& ${RPT_ALINKS} =~ "\",.+[TRC]K\""`is a statement that is TRUE when any other node is transmitting.

`/root/mykeyed1.sh 516221` is the script to be executed, passing the argument value 516221, when MYKEYED1 is true.

`s` is the event action for executing a shell command when MYKEYED1 is TRUE.

`t` is the event type for when MYKEYED1 goes TRUE.

The script `mykeyed1.sh` executes asterisk commands and processes to evaulate whether any further action is required, such as disconnecting the node that is transmitting. 
