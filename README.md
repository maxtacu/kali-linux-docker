Kali-Linux(LXDE)-docker VNC
=========================

Docker image to provide HTML5 VNC interface to access Kali-Linux container LXDE desktop environment.

Quick Start
-------------------------
This Kali Linux Docker image provides a minimal base install of the latest version of the Kali Linux Rolling Distribution. 
There are no tools added to this image, so you will need to install them yourself. For details about Kali Linux metapackages, 
check https://www.kali.org/news/kali-linux-metapackages/

Before start check Dockerfile to uncomment needed Kali Linux Metapackages

Run the docker image and open port `6080`

```
docker run -it --rm -p 6080:80 <image-id>
```

Browse http://127.0.0.1:6080/


Connect with VNC Viewer and protect by VNC Password
------------------

Forward VNC service port 5900 to host by

```
docker run -it --rm -p 6080:80 -p 5900:5900 <image-id>
```

Now, open the vnc viewer and connect to port 5900. If you would like to protect vnc service by password, set environment variable `VNC_PASSWORD`, for example

```
docker run -it --rm -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=mypassword <image-id>
```

A prompt will ask password either in the browser or vnc viewer.

To get into bash of container
```bash
sudo docker exec -i -t <container-id> /bin/bash
```

P.S. If you would run container in cloud vm, run first bellow command to vm in cloud to create ssh tunnel 
to your vm
```bash
ssh -i .ssh/private_key -L 6080:localhost:6080 -L 5900:localhost:5900 user@IP
```