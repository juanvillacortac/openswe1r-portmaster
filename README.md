# Star Wars: Episode I Racer — PortMaster Port

PortMaster package for **OpenSWE1R** on aarch64 handhelds (knulli, muOS, ArkOS, Batocera, etc.).

The engine is **not** vendored in this repo. It is included as a [git submodule](https://github.com/juanvillacortac/openswe1r) and built at release time. Game files (GOG/Steam) are **not** included; the end user installs them into `openswe1r/game/` on the device.

## Quick start

```bash
git clone --recurse-submodules https://github.com/juanvillacortac/openswe1r-aarch64-portmaster.git
cd openswe1r-aarch64-portmaster
./build.sh
```

**Host requirements (Docker build, default):** `git`, `docker`, and `zip` only. The cross-compiler, CMake, and sysroot live inside the Ubuntu 20.04 container (`docker/Dockerfile.aarch64`). First run builds the image and compiles the engine (~10–30 min).

### First-time setup (this workspace)

```bash
git init
git submodule add https://github.com/juanvillacortac/openswe1r.git openswe1r
cd openswe1r && git checkout gles-port && cd ..
git add .
git commit -m "Initial port repository"
```

Output:

| Path | In git? | Description |
|------|---------|-------------|
| `port/` | yes | Launcher, metadata, folder layout |
| `openswe1r/` | submodule | Engine source (fork) |
| `port/openswe1r/openswe1r.aarch64` | no | Built binary |
| `dist/openswe1r.zip` | no | PortMaster install zip |

## Supported firmware (PortMaster)

Requires **aarch64** and **PortMaster** with native **GLES** (Mali or equivalent).

| CFW | Ports folder (typical) | Status |
|-----|------------------------|--------|
| [knulli](https://knulli.org/) | `/userdata/roms/ports/` | Expected |
| [muOS](https://muos.dev/) | `/mnt/mmc/ROMS/Ports/` or `/roms/ports/` | Expected |
| [ROCKNIX](https://rocknix.org/) | `/roms/ports/` | Expected |
| [ArkOS](https://github.com/christianhaitian/arkos) | `/roms/ports/` or `/roms2/ports/` | Expected |
| [Batocera](https://batocera.org/) | varies by device | Expected |
| AmberELEC / JELOS / UnofficialOS | `/roms/ports/` | Expected (aarch64 devices) |

**Not supported:** 32-bit **armhf** devices (RG351P/M/V, R36S, etc.).

**Recommended hardware:** Anbernic H700 family (RG35XX Plus/H/SP, RG34XX, RG40XX) or similar aarch64 handheld with 2 GB RAM and Mali GPU.

## Install on device

1. Unzip `dist/openswe1r.zip` to your CFW's `ports/` folder.
2. Copy Racer files from GOG to `openswe1r/game/`.

Example:
```bash
unzip dist/openswe1r.zip -d /userdata/roms/ports/
```

If the game fails to start, check `openswe1r/log.txt` on the device SD card.

## Repo layout

```
.
├── build.sh                 # Main build entry point
├── docker/                  # Docker cross-build environment
├── port/                    # PortMaster files (tracked)
│   ├── Star Wars Episode I Racer.sh
│   ├── port.json, gameinfo.xml, README.md
│   └── openswe1r/           # Layout (no binary in git)
├── openswe1r/               # git submodule → fork
├── scripts/
│   ├── init-submodule.sh
│   ├── build-engine.sh
│   ├── setup-port-layout.sh
│   ├── package-port.sh
│   ├── package-release.sh
│   └── validate-port.sh
└── dist/                    # Generated zips (gitignored)
```

## Engine fork

GLES/handheld patches live in [juanvillacortac/openswe1r](https://github.com/juanvillacortac/openswe1r) (`gles-port` branch). Upstream: [OpenSWE1R/openswe1r](https://github.com/OpenSWE1R/openswe1r).

## PortMaster

- [Packaging guide](https://portmaster.games/packaging.html)