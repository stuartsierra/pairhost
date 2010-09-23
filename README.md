Pairhost: the ultimate EC2 remote pairing development workstation

by Stuart Sierra, http://stuartsierra.com/


Setup
=====

Run the script `bin/ready` to find out what pieces you're missing.

You'll need five things copied into this directory:

* The Amazon EC2 API tools, unzipped
* The Amazon EC2 *AMI* tools, unzipped
* The `cert-*.pem` file from your Amazon Web Services account
* The `pk-*.pem` file from your Amazon Web Services account
* The SSH private key file from your Amazon Web Services account, see below

The SSH private key file must be named `id_rsa-*` where `*` is the *name* of your Amazon Web Services keypair.  So, for example, if your keypair is named `my_company_key` then the SSH private key file must be named `id_rsa-my_company_key`


Finding and Starting Instances
==============================

Run `bin/list` to see a list of available instances.  It will look like this:

    ID         HOSTNAME
    i-1a2b3c4d stopped
    i-a5b6c7d8 stopped

"Stopped" instances are not currently running and are therefore available for you to use.

To start an instance, run `bin/start ID` where `ID` is an instance ID like `i-1a2b3c4d`.  The instance will start and boot, which takes 10 to 30 seconds.

When your instance is ready, the script will spit out a bunch of information, including the host name.  Running `bin/list` again will also show the instance's host name.

You can SSH in as user `pair` at the host.


Bootstrapping New Instances
===========================

Not automated or documented yet.  Sorry.


Opening and Closing Firewall Ports
========================================

EC2 does not use standard Linux firewalls.  Instead, the firewall must be configured through the Amazon API.  The script `bin/firewall` makes this easier.

Run `bin/firewall show` to see the list of currently open ports.

Run `bin/firewall open <port>` to open a port.

Run `bin/firewall close <port>` to close it again.


SSH Tunneling
=============

Don't open ports on the remote machine, use tunnels!  Run this on your local machine:

    ssh -f username@hostname -L local-port:hostname:remote-port -N

Where username and hostname are your login and the EC2 host name.

Now local-port on your local machine is tunneled to remote-port on the EC2 instance.


NX: Faster X-Windows in the Cloud
=================================

1. On the EC2 instance, start the NX server by running the alias `nx`

2. Download and install a (free) NX client for your operating system from http://nomachine.com/

3. From the client, initiate an NX session on the EC2 host.

4. Your pair starts an NX "Shadow" session on the same host, as the
same user, and attaches to your session.
