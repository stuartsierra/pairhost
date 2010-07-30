Pairhost: the ultimate EC2 remote pairing development workstation

by Stuart Sierra, http://stuartsierra.com/

Under development.


SSH Tunneling
=============

Don't open ports on the remote machine, use tunnels!  Run this on your local machine:

    ssh -f username@hostname -L local-port:hostname:remote-port -N

Where username and hostname are your login and the EC2 host name.

Now local-port on your local machine is tunneled to remote-port on the EC2 instance.


TightVNC: X-Windows in the Cloud
================================

1. Download the TightVNC Java client from http://www.tightvnc.com/download.php

2. Unzip the client.

3. On your local machine, tunnel port 5901:

    ssh -f username$hostname -L 15901:hostname:5901 -N

4. On the EC2 instance, start a VNC server:

    vncserver

5. On your local machine, run the TightVNC client like this:

    java -jar TightVncViewer.jar HOST localhost PORT 15901 "Restricted Colors" "Yes"


NX: Faster X-Windows in the Cloud
=================================

1. On the EC2 instance, download and install the "NX Free Edition for
Linux" from http://www.nomachine.com/

Use the i386 DEB packages.  You need to install the client, node, and
server packages, in that order.

2. Enable password-based SSH login to the EC2 instance. Create a new
user account with a password if necessary.

3. On the EC2 instance, start the NX server:

    sudo /usr/NX/bin/nxserver --start

4. Download and install the (free) NX client for your local operating system.

5. From the client, initiate an NX session on the EC2 host.

6. Your pair starts an NX "Shadow" session on the same host, as the
same user, and attaches to your session.
