# Migration

First move the `/home` and `/var` directories that are on the secondary hard drive to temporary directory names:

```
sudo mv /media/andrew/hdd/home /media/andrew/hdd/home_orig
sudo mv /media/andrew/hdd/var /media/andrew/hdd/varDELETE
```

Now create a mount point for the secondary hard drive:

```
sudo mkdir /hdd
sudo chmod 0755 /hdd
```

Backup /etc/fstab:

```
sudo cp /etc/fstab /etc/fstab.bak
```

Edit `/etc/fstab` using `lsblk -f` to identify the UID of the secondary hard drive:

```
# /etc/fstab
UUID=$UUID    /hdd ext4 defaults 0 2
```

Mount the secondary hard drive and then move `/home` and `/var` to the secondary hard drive:

```
sudo mount -a
sudo cp -pr /home /hdd/home
sudo cp -pr /var /hdd/var
sudo mv /home /home_old
sudo mv /var /var_old
cd /
sudo ln -s /hdd/home home
sudo ln -s /hdd/var var
```

`/hdd/home_orig` can then be merged manually into `/hdd/home`, taking care to not move all the dot files and to replace rather than merge.  A check list of files is provided in `DOTFILES.md`.

In `/etc/apparmor.d/usr.sbin.cupsd` replace to `/var` with `/hdd/var`, and `,var` with `,hdd/var`.  Do not create a back up in this directory as it will be read in as though it were config.  To restart cups run `sudo systemctl restart cups.service`.

Finally, before directories are accidentally backed up, delete `/home_old`, `/var_old`, `/hdd/home_orig` and `/hdd/varDELETE` when satisfied that the computer is working correctly.
