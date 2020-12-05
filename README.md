# node-js

This script deploys Node.js ready for app install

## :clipboard: Features

Here is whats installed:

 - Base system tools: build-essential, curl, lsb-release, git, procps, net-tools, nano, htop, iftop, mariadb-client
 - Node.js (version: `--lts` - changeable via `.env` file)
 - Updates npm
 - pm2
 
## :arrow_forward: Install

Should be done on a **clean ubuntu 20.04 server**!

```
wget https://raw.githubusercontent.com/deploy-script/node-js/master/script.sh && bash script.sh
```
