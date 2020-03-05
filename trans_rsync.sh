#!/bin/bash

#Set to 1 delete file after copy
del_file_after="1"

#limit bandwidth
limit_band="0"
max_band="1000"

save_path="/nas101/dave/Downloaded Torrents/"

file_share_mnt_path="/nas101/dave"

mnt_path_check="0"

rsync_opts="-abh --info=progress2 "

if [ "$limit_band" = "1" ]; then
rsync_opts="${rsync_opts} --bwlimit=$max_band "
echo $rsync_opts
fi

if [ "$del_file_after" = "1" ]; then
rsync_opts="${rsync_opts} --remove-source-files "
echo $rsync_opts
fi

if grep -qs $file_share_mnt_path  /proc/mounts; then
    mnt_path_check="1"
else
    mnt_path_check="0"
fi

if [ "$mnt_path_check" == "0" ]; then
echo "Could not access the file share"
sleep 10
exit 1
fi

if [ ! -d "$save_path" ]; then
echo "Could not find $save_path"
sleep 10
exit 1
fi

echo xterm -geometry 60x1+1+1 -T "Copying $TR_TORRENT_NAME" -e  "rsync $rsync_opts '$TR_TORRENT_DIR/$TR_TORRENT_NAME' '$save_path'" >> /tmp/copylog

xterm -geometry 60x1+1+1 -T "Copying $TR_TORRENT_NAME" -e  "rsync $rsync_opts '$TR_TORRENT_DIR/$TR_TORRENT_NAME' '$save_path'" 1>&2
