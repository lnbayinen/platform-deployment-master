
RSA Netwitness Base ISO Creation

Script(s): "isobuild.sh" 
Creates dvd, usb and usbboot iso images, the latter being used for usb flash drive installs. Requires local installation of the genisoimage, isomd5sum and squashfs-tools packages.

File(s): "buildparam.prop" 
Contains the Jenkins job build parameters used by the "isobuild.sh" script. 
"CODEVERSION=" 
The code release version path in the git repository, e.g. ng11.0 for nextgen 11.0. 
"CODEPATH=" 
The relative path of code artifacts in the jenkins workspace. 
"CENTOSISO=" 
The CentOS dvd iso release used for creating the jenkins workspace iso template folders, assumed to be a local loop mount on the jenkins worker node. 
"DVDISODIR=" 
The jenkins workspace folder used for creating dvd iso images. 
"USBISODIR=" 
The jenkins workspace folder used for creating usb iso images. 
"BOOTISODIR=" 
The jenkins workspace folder used for creating usbboot iso images.  
"BUILDBINURL=" 
The URL of the hypertext protocol file server for downloading required binaries needed for iso customization. 
"MEGACLIRPM=" 
Name of the rpm containing the Avago Mega Raid CLI binary used to configure hardware raid devices. 
"RSAREPO=" 
Local path of the RSA Netwitness software repository required for populating the ISO Packages installation directories for the dvd and usb iso images. 
"BOOTSTRAPREPO=" 
Local path of the RSA Netwitness bootstrap repository required for creating the bootstrap-repo.tgz archive on the dvd and usb iso images. 
"KEYSREPO=" 
Local path of the RSA Netwitness keys repository, required for creating the bootstrap-repo.tgz archive on the dvd and usb iso images.  
"ISONAMESTR=" 
The string pre-pended to the iso file names along with the jenkins job build number, e.g. for the dvd iso "${ISONAMESTR}.${BUILD_NUMBER}-dvd.iso". 
"ARTIFACTPOST=" 
The local file path to move the created iso artifacts to. The "RSAREPO=", "BOOTSTRAPREPO=", "KEYSREPO=" and "ARTIFACTPOST=" jenkins build parameters are implemented as nfs mounts on the worker nodes. 

File(s): "generateAllKickstarts.sh", "generateFileInjector.sh", "kickstartStubs", "generate_appliance.ks.sh", "hardware_check.sh" and "post.sh".   
Series of scripts used to assemble the "appliance.ks" kickstart file on dvd and usbboot iso images. The "hardware_check.sh" script contains the %pre install kickstart routines, "post.sh" containing all %post install kickstart calls. The "generate_appliance.ks-sh" file is a kickstart template containing any lines from the command section not created by "kickstartStubs", the %Packages section as well as any %pre and %post section function calls.

File(s): "ova.ks".  
The kickstart used by Packer to create the OVA build artifacts. It is copied to the ISO root file system on the dvd image. 

File(s): "isolinux.cfg" & "syslinux.cfg"   
The custom RSA Netwitness BIOS boot installation menus added to the dvd and usbboot iso images, repectfully. 

