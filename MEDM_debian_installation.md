# Installing Remote MEDM for Debian 

(c) Yasmeen Asali, March 2019

You can install Remote MEDM screens for debian with the following commands in terminal.<br>

First, change to the root user:<br>
	`su -`<br>

Add the Debian LSCSoft repository to your system by adding the following to the file `/etc/apt/sources.list.d/lscsoft.list:`<br>
	```
	deb http://software.ligo.org/lscsoft/debian stretch contrib
	deb-src http://software.ligo.org/lscsoft/debian stretch contrib
	```

Force install the LSCSoft keyring:<br>
	`apt-get update --allow-insecure-repositories`<br>
	`apt-get -y --force-yes install lscsoft-archive-keyring`<br>

Next, you can install the `cds-workstation` umbrella package which contains MEDM and the launcher scripts. <br>
	`wget -c http://apt.ligo-wa.caltech.edu/debian/pool/stretch-unstable/cdssoft-release-stretch/cdssoft-release-stretch_1.3.2_all.deb`<br>
	`dpkg -i cdssoft-release-stretch_1.3.2_all.deb` <br>
	`apt update`<br>
	`apt install cds-workstation`<br>

Now, Remote MEDM should be installed. You can leave the root user with `exit` then launch MEDM viewer as follows:<br>
	`medm_lho -u albert.einstein`<br>
	`medm_llo -u albert.einstein`<br>
 

