# Magisk-Module-with-clang19
This repository contains a Magisk Module with clang 19 for arm64 CPUs

To create the ZIP file with the Magisk Module, clone or download the repository and execute the script
```
./create_zip.sh 
```
from the repository


**Short documentation for the Magisk Module with clang 19**

After installing the Magisk Module, the **clang19** files are located in the directory 

**/system/usr/clang19**

The **clang19**, **make**, and **pkg-config** binaries are in the directory

**/system/usr/clang19/bin**

The files from the NDK are in the directory

**/system/usr/ndk/r27b**

The sysroot from the NDK is in the directory

**/system/usr/ndk/r27b/sysroot**


Use 
```
. /system/bin/init_clang19_env
```
to init the environment for the **clang19**. This scripts defines all necessary environment variables (including the PATH variable) to use the clang.


Source Code used to create the binaries
---------------------------------------

The repo with the source code for **clang** is:

[https://android.googlesource.com/toolchain/llvm-project](https://android.googlesource.com/toolchain/llvm-project)

The source code was checked out in **10/2024**

See the file 

**source/myconfigure** 

in the Magisk Module for the cmake options used to prepare the build process for the **clang19**.
The **clang19** binaries were compiled on a machine running the Linux OS with Cross Compiler from the **Android NDK r27b**.


The Android NDKs are available here:

[https://developer.android.com/ndk/downloads](https://developer.android.com/ndk/downloads)

The source code for the **make** binary is available here:

[https://ftp.gnu.org/gnu/make/](https://ftp.gnu.org/gnu/make/)


The source code for **pkg-config** is avialable here:

[https://pkgconfig.freedesktop.org/releases/](https://pkgconfig.freedesktop.org/releases/)

