## Notes

Star Wars: Episode I Racer (1999) by **LucasArts**. This port runs the **OpenSWE1R** engine (thanks to [OpenSWE1R Maintainers](https://github.com/OpenSWE1R/openswe1r) and contributors).

You must own the game and copy the original files from **GOG** into `openswe1r/game/`. The original executable `swep1r.exe` is loaded by the engine to extract race and art assets via x86 emulation; the open-source renderer replaces the original Direct3D path with OpenGL ES.

Launch follows the [PortMaster shell template](http://portmaster.games/packaging.html) in the `*.sh` wrapper. Low-RAM swap (`DEVICE_RAM < 2`) lives in the launcher; the engine loads level + sound data into RAM. Game data paths are resolved case-insensitively on Linux (ext4).

Saves and settings are stored under `openswe1r/conf/`.

## Supported firmware (PortMaster)

**aarch64 handhelds:** Requires **PortMaster** with native **GLES** (Mali or equivalent). GLES 3.0+ recommended; the engine falls back to GLES 2.0.

| CFW | Ports folder (typical) | Status |
|-----|------------------------|--------|
| [knulli](https://knulli.org/) | `/userdata/roms/ports/` | Expected |
| [muOS](https://muos.dev/) | `/mnt/mmc/ROMS/Ports/` or `/roms/ports/` | Expected |
| [ROCKNIX](https://rocknix.org/) | `/roms/ports/` | Expected |
| [ArkOS / dArkOS](https://github.com/christianhaitian/arkos) | `/roms/ports/` or `/roms2/ports/` | Expected |
| AmberELEC / JELOS / UnofficialOS | `/roms/ports/` | Expected (aarch64 devices) |

**Not supported:** 32-bit **armhf** devices.

**Recommended hardware (aarch64):** Anbernic H700 family (RG35XX Plus/H/SP, RG34XX, RG40XX) or similar aarch64 handheld with 2 GB RAM and Mali GPU.

## Installation

1. Unzip the port to your CFW's `ports/` folder (see table above).
2. Copy Racer game data to `openswe1r/game/` (`Data/`, `swep1r.exe`, `install.lid`).
3. Launch **Star Wars Episode I Racer** from PortMaster.

If the game fails to start, check `openswe1r/log.txt` on the device SD card.

**SDL / video:** The port links dynamically against the firmware's SDL (kmsdrm, GLES, audio). Do **not** ship `libSDL2*.so` in `libs.aarch64/`. System GLES/EGL are linked at runtime via `SDL_GL_GetProcAddress`.

## Controls (handheld)

The engine uses SDL2 native gamepad; `openswe1r.gptk` is a kill-only gptokeyb config (no input injection, Select+Start quits).

| Button | Action |
|--------|--------|
| Left stick / D-pad | Menu / steer |
| A | Confirm |
| B | Back |
| Start | Pause menu |
| Select + Start | Quit port |

## Build (porters)

Engine submodule + scripts live in the [port repository](https://github.com/juanvillacortac/openswe1r-aarch64-portmaster). From a clone with submodules:

```shell
./build.sh
```

Fork with GLES/handheld patches: [juanvillacortac/openswe1r](https://github.com/juanvillacortac/openswe1r).

## Thanks

- [LucasArts](https://www.lucasarts.com/) for the original game
- [OpenSWE1R](https://github.com/OpenSWE1R/openswe1r) maintainers and community
- [PortMaster](https://portmaster.games/) for handheld port tooling