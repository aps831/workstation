# Migration

First move the `/home` directory that is on the secondary hard drive to a temporary directory name:

```
sudo mv /media/andrew/hdd/home /media/andrew/hdd/home_orig
```

Now create a mount point for the secondary hard drive:

```
sudo mkdir /hdd0
sudo chmod 0755 /hdd0
```

Backup /etc/fstab:

```
sudo cp /etc/fstab /etc/fstab.bak
```

Edit `/etc/fstab` using `lsblk -f` to identify the UID of the secondary hard drive:

```
# /etc/fstab
UUID=$UUID    /hdd0 ext4 defaults,nofail 0 2
```

Mount the secondary hard drive and then move `/home` to the secondary hard drive:

```
sudo mount -a
sudo cp -pr /home /hdd/home
sudo mv /home /home_old
cd /
sudo ln -s /hdd/home home
```

`/hdd/home_orig` can then be merged manually into `/hdd/home`, taking care to not move all the dot files and to replace rather than merge. A check list of files is provided in `DOTFILES.md`.

Finally, before directories are accidentally backed up, delete `/home_old` and `/hdd/home_orig` when satisfied that the computer is working correctly.
