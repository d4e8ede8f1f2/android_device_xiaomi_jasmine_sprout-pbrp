#!/sbin/sh

 ## Do not forget to patch ;)
 # relink()
 # {
 #  cp $1 ${1}_old
 #  sed 's|/system/bin/linker64|///////sbin/linker64|' "${1}_old" > "$1"
 #  chmod 755 $1
 #  rm ${1}_old
 # }
 #
 # relink android.hardware.boot@1.0-service
 # relink android.hardware.gatekeeper@1.0-service-qti
 # relink android.hardware.keymaster@3.0-service-qti
 # relink qseecomd
 # relink time_daemon

finish()
{
 umount /s
 rmdir /s
 setprop crypto.ready 1
 exit 0
}

suffix=$(getprop ro.boot.slot_suffix)

if [ -z "$suffix" ]; then
 suf=$(getprop ro.boot.slot)
 suffix="_$suf"
fi

syspath="/dev/block/bootdevice/by-name/system$suffix"
mkdir /s
mount -t ext4 -o ro "$syspath" /s

device_codename=$(getprop ro.boot.hardware)
is_fastboot_twrp=$(getprop ro.boot.fastboot)

if [ ! -z "$is_fastboot_twrp" ]; then
 osver=$(getprop ro.build.version.release_orig)
 patchlevel=$(getprop ro.build.version.security_patch_orig)
 setprop ro.build.version.release "$osver"
 setprop ro.build.version.security_patch "$patchlevel"
 finish
fi

if [ -f /s/system/build.prop ]; then
 # TODO: It may be better to try to read these from the boot image than from /system
 osver=$(grep -i 'ro.build.version.release' /s/system/build.prop  | cut -f2 -d'=')
 patchlevel=$(grep -i 'ro.build.version.security_patch' /s/system/build.prop  | cut -f2 -d'=')
 setprop ro.build.version.release "$osver"
 setprop ro.build.version.security_patch "$patchlevel"
 finish
else
 # Be sure to increase the PLATFORM_VERSION in build/core/version_defaults.mk to override Google's anti-rollback features to something rather insane
 osver=$(getprop ro.build.version.release_orig)
 patchlevel=$(getprop ro.build.version.security_patch_orig)
 setprop ro.build.version.release "$osver"
 setprop ro.build.version.security_patch "$patchlevel"
 finish
fi
