#
# Customization script for the Magisk Module with clang19 and NDK r27b
#
# History
#   30.10.2024 /bs
#     initial release
#   11.11.2024 /bs
#      the instructions to compile the examples are corrected (the environment variable CPP_LDFLAGS is not used)
#
#
# Notes:
#
# This Magisk Module contains files for arm64 CPUs
#
# Documentation for creating Magisk Modules: https://topjohnwu.github.io/Magisk/guides.html
#
# Environment variables that can be used:
#
#    MAGISK_VER (string): the version string of current installed Magisk (e.g. v20.0)
#    MAGISK_VER_CODE (int): the version code of current installed Magisk (e.g. 20000)
#    BOOTMODE (bool): true if the module is being installed in the Magisk app
#    MODPATH (path): the path where your module files should be installed
#    TMPDIR (path): a place where you can temporarily store files
#    ZIPFILE (path): your module’s installation zip
#    ARCH (string): the CPU architecture of the device. Value is either arm, arm64, x86, or x64
#    IS64BIT (bool): true if $ARCH is either arm64 or x64
#    API (int): the API level (Android version) of the device (e.g. 21 for Android 5.0)
#

# -----------------------------------------------------------------------------

DISCLAIMER="
to be written
"

# -----------------------------------------------------------------------------

# define constants
#
__TRUE=0
__FALSE=1

# -----------------------------------------------------------------------------
# init global variables
#

MODULE_VERSION="$( grep "^version=" $MODPATH/module.prop  | cut -f2 -d "=" )"

MODULE_NAME="$( grep "^id=" $MODPATH/module.prop  | cut -f2 -d "=" )"

MODULE_DESC="${MODULE_NAME} ${MODULE_VERSION}"

CLANG_VERSION="19"

SAMPLE_PROGRAMS="helloworld_in_c.c helloworld_in_c++.cpp"

# -----------------------------------------------------------------------------
#
if [ 0 = 1 -o -r /data/local/tmp/debug ] ; then
  LOGFILE="/data/local/tmp/${MODULE_NAME}_customize.log"

  ui_print "Writing all messages to the log file ${LOGFILE}"
  exec 1>${LOGFILE} 2>&1
  set -x
fi

# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------

function LogMsg {
  ui_print "$*"
}

function LogInfo {
  LogMsg "INFO: $*"
}

function LogWarning {
  LogMsg "WARNING: $*"
}

function LogError {
  LogMsg "ERROR: $*"
}


# -----------------------------------------------------------------------------

LogMsg "The current environment for this installation is"

LogMsg "The version of the installed Magisk is \"${MAGISK_VER}\" (${MAGISK_VER_CODE})"

LogInfo "BOOTMODE is \"${BOOTMODE}\" "
LogInfo "MODPATH is \"${MODPATH}\" "
LogInfo "TMPDIR is \"${TMPDIR}\" "
LogInfo "ZIPFILE is \"${ZIPFILE}\" "
LogInfo "ARCH is \"${ARCH}\" "
LogInfo "IS64BIT is \"${IS64BIT}\" "
LogInfo "API is \"${API}\" "

# -----------------------------------------------------------------------------

# example output for the variables:


#  The version of the installed Magisk is "25.0" (25000)
#  INFO: BOOTMODE is "true" 
#  INFO: MODPATH is "/data/adb/modules_update/PlayStore_for_MicroG" 
#  INFO: TMPDIR is "/dev/tmp" 
#  INFO: ZIPFILE is "/data/user/0/com.topjohnwu.magisk/cache/flash/install.zip" 
#  INFO: ARCH is "arm64" 
#  INFO: IS64BIT is "true" 
#  INFO: API is "32"


# -----------------------------------------------------------------------------

LogMsg "Installing the Magisk Module with ${MODULE_NAME} for Android \"${MODULE_VERSION}\" ..."

LogMsg "Checking the OS configuration ..."

ERRORS_FOUND=${__FALSE}

MACHINE_TYPE="$( uname -m )"

# check the current CPU
#
LogMsg "Checking the type of the CPU used in this device ...."

LogMsg "The CPU in this device is a ${ARCH} CPU"
LogMsg "The machine type reported by \"uname -m\" is \"${MACHINE_TYPE}\" "


if [ "${ARCH}"x != "arm64"x ] ; then
  abort "This Magisk module is for arm64 CPUs only"
fi

# ---------------------------------------------------------------------

LogMsg "Installing clang19 and the NDK r27b files for Linux ..."

LogMsg "Correcting the permissions for the new files ..."

cd "${MODPATH}"

# first the directories with data and config files 
# 
for i in etc include usr ; do

  [[ $i != /\* ]] && CUR_ENTRY="${MODPATH}/system/$i" || CUR_ENTRY="$i"

  [ ! -d "${CUR_ENTRY}" ] && continue

  LogMsg "Processing the files in the directory ${CUR_ENTRY} ..."
  set_perm_recursive "${CUR_ENTRY}" 0 0 0755 0644 u:object_r:system_file:s0
  chcon -R -h u:object_r:system_file:s0 "${CUR_ENTRY}"
done


echo "#####################################"


# now the directories with binaries
# 
for i in bin lib lib64 usr/bin usr/clang${CLANG_VERSION}/bin usr/clang${CLANG_VERSION}/libexec ; do

  [[ $i != /\* ]] && CUR_ENTRY="${MODPATH}/system/$i" || CUR_ENTRY="$i"
	
  [ ! -d "${CUR_ENTRY}" ] && continue

  LogMsg "Processing the files in the directory ${CUR_ENTRY} ..."

  set_perm_recursive "${CUR_ENTRY}" 0 0 0755 0755 u:object_r:system_file:s0

  chcon -R -h  u:object_r:system_file:s0 "${CUR_ENTRY}"
done

echo "Copying the sample programs to /data/local/tmp ..."

for CUR_FILE in ${SAMPLE_PROGRAMS} ; do
  if [ -r "${MODPATH}/${CUR_FILE}" ] ; then
    if [ -r "/data/local/tmp/${CUR_FILE}" ] ; then
      echo "The file \"/data/local/tmp/${CUR_FILE}\" already exists"
    else
      echo "Creating the file \"/data/local/tmp/${CUR_FILE}\" ..."
      cp "${MODPATH}/${CUR_FILE}" "/data/local/tmp/${CUR_FILE}"
    fi
  else
    LogWarning "The file \"${MODPATH}/${CUR_FILE}\" does not exist"
  fi
done


cat <<EOT

Use

. /system/bin/init_clang19_env

to init the environment for the clang19

To test the clang compiler environment use

cd /data/local/tmp
clang \${CFLAGS} \${LDFLAGS} -o helloworld_in_c helloworld_in_c.c  && ./helloworld_in_c

To test the clang++ compiler environment use

cd /data/local/tmp
clang++ \${CPPFLAGS} \${LDFLAGS}  -o helloworld_in_c++ ./helloworld_in_c++.cpp && ./helloworld_in_c++


EOT

