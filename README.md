Kali-Linux(LXDE)-Docker image with SSH, MOSH, and VNC
=========================

Docker image with SSH, MOSH, and **HTML5** VNC interface access to Kali-Linux container LXDE desktop environment.

Quick Start
-------------------------
This Kali Linux Docker image provides a minimal base install of the latest version of the Kali Linux Rolling Distribution.

Basic security tools are added to this image. To quickly extend the toolset, check https://www.kali.org/news/kali-linux-metapackages/

SSH access is assymetric key only. You will need to update the following files with public keys of your own before building an image:
```
authorized_keys_root -- keys for access to the root account
authorized_keys_ccc  -- keys for the CCC account which does not allow interactive login (see below)
```

You should probably also edit docker-compose.yml and change the VNC_PASSWORD from the default value "CHANGEME!"

By default docker-compose will only expose SSH on port 443 (to make it easier to reach through firewalls) and MOSH on 60001/udp. VNC access requires SSH tunneling (see below).

Build the image:
```
docker-compose build
```

Run the image:
```
docker-compose up -d
```

SSH to the container host's port 443 (this will ssh into the container as the port is redirected)
```
ssh root@host -p 443
```

Alternately over mobile internet, use MOSH
```
mosh "root@host 443"
```

Connecting with VNC
------------------

By default VNC can only be accessed via an SSH tunnel. This limits the container's attack surface, and eliminates the need for VNC encryption.

First SSH into the container and setup tunnels to port 80 and 5900
```
ssh root@host -p443 -L 6080:localhost:80 -L 5900:localhost:5900
```

Then access the VNC webui by navigating to:
```
http://localhost:6080/vnc.html
```

The CCC user
------------------

The CCC user is intended for SSH tunnels. One use is to allow mobile devices, leave-behinds, and other devices with dynamic IPs that are often behind NAT to publish an easily accessible SSH port on a public IP.

This can be accomplished using autossh. For example, on the device:

```
autossh -M 10984 -q -f -N -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -i ~/.ssh/id_rsa_ccc -R 0.0.0.0:6666:localhost:22 ccc@host -p 443
```

Will create a persistent SSH tunnel to the container that redirects traffic from the container's port 6666 to port 22 on a mobile device running autossh.

You would then SSH into that device from anywhere on the internet like so:

```
ssh -t root@host -p 443 'ssh -t root@127.0.0.1 -p 6666'
```

Here's a slightly more reliable script for running a persistent autossh C&C tunnel:
```
#!/bin/sh
export AUTOSSH_DEBUG=1
export AUTOSSH_GATETIME=0
export AUTOSSH_LOGFILE=/root/ccc/ccc.log

autossh -M 10984 -f -q -N -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -i /root/ccc/id_rsa_ccc -R 0.0.0.0:6666:localhost:22 ccc@host -p 443
```

Persistence
------------------
By default docker-compose will mount the directory volumes/root as /root/host inside the container to allow for persistent storage. This is a minor security risk as it allows limited access to the host filesystem.
