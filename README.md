docker-android
==================

Create a [Docker] based environment to build Android ROMs.

This Dockerfile will create a docker container which is based on Debian Stretch.
It will install the "repo" utility and any other build dependencies which are required to compile most Android ROMs. Some ROM distributions may have additional dependencies that need to be fulfilled.

The main working directory is a shared folder on the host system, so the Docker container can be removed at any time.

**NOTE:** Remember that Android ROMs are huge projects. It will consume a large amount of disk space (~80 GB) and it can easily take hours to build.

### How to run/build

**NOTES:**
* You will need to [install Docker][Docker_Installation] to proceed!
* If an image does not exist, ```docker build``` is executed first

```
git clone https://github.com/alebcay/docker-android.git
cd docker-android
./run.sh
```

The `run.sh` script accepts the following switches:

* -u|--enable-usb - runs the container in privileged mode (this way you can use adb right from the container)
* -r|--rebuild - force rebuild the image from scratch
* -ws|--with-su - Sets the WITH_SU environment variable to true (your builds will include the su binary)

The container uses "tmux" to run the shell. This means that you will be able to open additional shells using [tmux shortcuts](https://gist.github.com/andreyvit/2921703).

### Credits
Based on [Michael Stucki's](https://github.com/stucki/) [docker-lineageos](https://github.com/stucki/docker-lineageos). This project builds off of `docker-lineageos` in the following ways:
- Configures `backports` and `sid` repositories
- Upgrades `git` to `>= 2.18` and configures it to take advantage of [Git protocol version 2](https://opensource.googleblog.com/2018/05/introducing-git-protocol-version-2.html)
- Installs `libncursesw6`, needed by some newer Clang-based toolchains
- Uses `tmux` instead of `screen`
- Configures locales correctly to display Unicode characters so that custom ROM build scripts display properly

[Docker]:                      https://www.docker.io/
[LineageOS]:                   http://lineageos.org/
[Docker_Installation]:         https://www.docker.io/gettingstarted/
[Screen_Shortcuts]:            http://www.pixelbeat.org/lkdb/screen.html
[CyanogenMod_Building_Basics]: https://web-beta.archive.org/web/20161224192643/http://wiki.cyanogenmod.org/w/Development
[LineageOS_Build_Nexus5]:    https://wiki.lineageos.org/devices/hammerhead/build
[Discussion thread @ XDA developers]: http://forum.xda-developers.com/showthread.php?t=2650345
[dotcloud/docker#2224]:        https://github.com/dotcloud/docker/issues/2224
