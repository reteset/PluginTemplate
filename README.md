## Assembly Plugin Template For AMS8
This repository contains an assembly dll template to build an AMS8  Actions plugin. There is also an AMS project that implements a demo compiler with FASM as backend

This template is used to store Lua scripts in a Windows DLL file with a LMD extension which is considered as an AMS8 actions plugin
This template framework **does not offer any kind of source code protection**  ,but this might be useful if you do not want to keep your scrips in a traditional way (in autorun.cdd)
This project can also be used to automate creation of script storage files

The repository contains 2 base folders **Template** and **Tiny Plugin Maker**

#### Tiny Plugin Maker :
This folder contrins an AMS8 project that also contains the **Template** folder in **AutoPlay\Docs**
This project requires FASM to compile Assembly template file to a DLL
The FASM compiler is already included , You can download latest 
 version from here : [Flat Assembler](https://flatassembler.net/download.php)
This sample project shows how to use this template and how to convert your scripts to LMD files quickly 
#### Template :
This folder contains the template assembly file for reference only.

>If you have questions about this framework then please post them to follwing forum link :

 [Reteset Software Support Forums](https://www.reteset.net/forums/viewforum.php?f=7)

If you are not familiar with GIT or github ; click to **Clone or download** button then click to **Download ZIP** to download everything or [Just Click Here](https://github.com/reteset/PluginTemplate/archive/master.zip)
 