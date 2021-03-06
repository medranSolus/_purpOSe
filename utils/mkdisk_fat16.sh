#!/bin/bash
bin_dir=./"$1"/bin
obj_dir=./"$1"/obj/bootloader
mount_dir="$bin_dir"/root
disk_file="$bin_dir"/disk.img
volume_name="PurpOSe    "
root_entries=512
reserved_sectors=2
sectors_per_cluster=4
sector_size=512

if [ -z "$1" ]; then
    echo "Must specify target architecture!"
    exit 1
fi
shopt -s extglob
rm -f "$disk_file"
dd if=/dev/zero of="$disk_file" bs=10M count=1 >& /dev/null
losetup -fP "$disk_file"
mkfs.fat -a -c -n "$volume_name" -s "$sectors_per_cluster" -S "$sector_size" -F 16 -r "$root_entries" -R "$reserved_sectors" "$disk_file" >& /dev/null
mkdir -p "$mount_dir"
mount -o loop /dev/loop0 "$mount_dir"
cp -r "$bin_dir"/!(root|disk.img) "$mount_dir"
umount "$mount_dir"
losetup -d /dev/loop0
rm -rf "${bin_dir:?}"/!(disk.img)
cat "$obj_dir"/mbr.bin "$disk_file" > "$bin_dir"/temp.img
mv "$bin_dir"/temp.img "$disk_file"
./utils/quick_tools/bin/insert_vbr_fat16_code "$1"
chmod a+rw "$disk_file"