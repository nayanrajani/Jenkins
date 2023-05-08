# Jenkins

## Introduction & Installation

- Jenkins <https://www.jenkins.io/>

  - Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.

  - Jenkins can be installed through native system packages, Docker, or even run standalone by any machine with a Java Runtime Environment (JRE) installed.

- VirtualBox <https://www.virtualbox.org/wiki/Downloads>
  - Use a Centos 7 ISO
  - create a VM in virtual box and follow the procedure you want and select the ISO Image
  - I provided 15 GB od disk space and 2 GB of RAM.

  - After booting up you need to select via up and down arrow key and hit enter on "Install Centos 7".
  - wait for a while, with the help of tab just hit continue button with Enter.
  - click on the installation mathod and set to automatic and done
  - click on network and enable the ethernet option and done.
  - Begin Installation.
  - give root user a password and remember it.
  - create a user name as jenkins and give password as well.
  - wait for it to complete and then REBOOT.
    - login with jenkins and password
    - on login check with "ip a" and copy the IP

  - Download Putty and change appearence accordingly.
  - now open putty under session add ip in Host section
  - and enter name down and click on save
  - to open the save section, click on name, load and then open.
  - you need to login again with jenkins and password. [DO noe close the virtual box section, minimise it]