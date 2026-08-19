# Third-party notices

## LG Electronics monitor package

The official LG package is a local build input only. It is not redistributed by this repository, and its files remain subject to LG's rights.

- Source: `https://gscs-b2c.lge.com/downloadFile?fileId=oIs3kMmpDVrBHvcbdef4Q`
- Archive SHA-256: `f402821ec78bfde6d51ec9b1c28565f78a715134968909af27dbe7a5a96c9ae9`
- Profile: `LG HDR WQHD+.icm`
- Profile SHA-256: `d2af60dd9dad04d6f75b6cb2416a33547a4a4194d112062384260c6250e1b34c`

The archive also contains LG's original INF, catalog, x86 setup tools, and x64 installer. None of those files is included here. The build extracts only the profile into the ignored `out` directory.

## Windows Driver Kit

`InfVerif.exe` and `Inf2Cat.exe` are Microsoft Windows Driver Kit tools. They are required on the build machine and are not bundled or redistributed here.
