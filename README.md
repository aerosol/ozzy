# Ozzy

This is a quick 2h sketch, more to come.

A Slack bot that wraps your ansible and other things, turning it into chatops,
so your team can `@ozzy deploy our stuff` instead of using things that can
be easily abused.

Ozzy will also monitor your http(s) services and shout if the need be.

It'll also allow more sophisticated configs and stream large stdouts via a DM
to the calling chatop.

At the moment, all ozzy knows is:

```
---
triggers:
  - on: "uname"
    shell: "uname -a"

  - on: "temp"
    shell: "ls /tmp"
```
