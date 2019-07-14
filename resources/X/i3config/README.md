i3 status using Conky
=====================

# Installation

**First** change the *scripts* variable in i3status.sh to the directory where you have cloned this repo.

**Add** this to your **bar** block in your i3 config file:

```
bar {
    status_command $i3dir/i3status-conky/i3status.sh
 
```

Most Debian/Ubuntu users should open the *conkystatus* file, scroll down to **Networking** section and read the comment.


