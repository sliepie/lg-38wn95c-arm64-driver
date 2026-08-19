# LG 38WN95C ARM64 monitor package

This is an unofficial, INF-only ARM64 monitor package for the LG 38WN95C. It records the monitor's mode metadata and associates the official LG color profile while Windows continues to use the installed ARM64 display adapter driver.

This project does not port LG's x64 executable driver, install a GPU driver, add HDR support, repair Thunderbolt, or provide LG's OnScreen Control/DDC tools.

## Build

Obtain the official LG archive separately. It is a build input and is ignored by this repository. Run the build from this directory with PowerShell and the Windows Driver Kit tools on `PATH`:

```powershell
.\build.ps1 .\LG_HDR_WQHD+_774C_774D_774E_38WN95C.zip
```

The script verifies the archive and ICM SHA-256 values, extracts only `LG HDR WQHD+.icm` into `out`, copies the project INF, and runs `InfVerif` and `Inf2Cat` for ARM64. The build fails when either validation tool is unavailable or reports an error.

The generated package contains:

- `out\lg-38wn95c-arm64.inf`
- `out\LG HDR WQHD+.icm`
- `out\lg-38wn95c-arm64.cat`

The generated catalog must be signed with a certificate trusted by the target Windows installation before normal driver-store installation.

## Releases

Releases require a semver tag such as `v1.0.0` pointing to a commit in `main`'s history. Pushing such a tag runs validation and publishes a source-only GitHub Release; the workflow rejects tags outside `main` before packaging. Its ZIP contains only this project's `README.md`, `LICENSE`, `THIRD_PARTY_NOTICES.md`, `build.ps1`, and `driver\lg-38wn95c-arm64.inf`, plus a SHA-256 sidecar.

The release is not a signed or directly installable driver package. It contains no LG ZIP, ICM profile, installer, catalog, executable, or trusted signature. Obtain LG's official archive separately, build locally with the WDK, and sign the generated catalog with a certificate trusted by the target Windows installation.

## Hardware IDs and modes

| Hardware ID | Connection | Range | Preferred mode |
| --- | --- | --- | --- |
| `MONITOR\GSM774C` | HDMI | 30.0–125.0 kHz, 48.0–75.0 Hz | 3840×1600 at 75 Hz |
| `MONITOR\GSM774D` | DisplayPort | 30.0–250.0 kHz, 48.0–144.0 Hz | 3840×1600 at 120 Hz |
| `MONITOR\GSM774E` | Thunderbolt | 30.0–250.0 kHz, 48.0–144.0 Hz | 3840×1600 at 120 Hz |

All three entries associate `LG HDR WQHD+.icm` and record a maximum resolution of 3840×1600.

## Installation

After building and signing the catalog, install the package on the ARM64 system with:

```powershell
pnputil /add-driver .\out\lg-38wn95c-arm64.inf /install
```

Verify the selected monitor package and color-profile association in Device Manager and Windows display settings. The package does not replace the display adapter driver.

## License

The project-authored files are licensed under the MIT License in [LICENSE](LICENSE). LG-owned files are not part of this repository; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
