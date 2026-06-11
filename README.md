# Strecs3D Flatpak

Flatpak build configuration for [Strecs3D](https://github.com/tomohiron907/Strecs3D) - FEM-based infill optimizer for 3D printing.

## Prerequisites

- flatpak
- flatpak-builder
- The KDE 6.7 runtime and SDK

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --user org.kde.Platform//6.7 org.kde.Sdk//6.7
```

## Building

```bash
make build
```

Or manually:

```bash
flatpak-builder --force-clean --ccache --install-deps-from=flathub build-dir com.github.tomohiron907.Strecs3D.yml
```

## Installing

```bash
make install
```

## Running

```bash
flatpak run com.github.tomohiron907.Strecs3D
```

## What this does

1. **Patches Strecs3D** to add Linux support:
   - Replaces the `FATAL_ERROR` on non-Windows/macOS with a UNIX branch
   - Adds `cmake/linux_settings.cmake` for library linking and RPATH
   - Adds `UI/platform/linux/WindowUtils.cpp` (stub for title bar customization)
   - Adds `install(TARGETS ...)`, icon, and license install rules
2. **Builds all dependencies** from source (9 modules):
   - libb2, pugixml, nlohmann_json, libzip, lib3mf
   - OpenCASCADE Technology (OCCT) v7.8.1
   - VTK v9.3.1 (with Qt6, Imaging, Rendering groups)
   - GMSH v4.12.2 (with OpenCASCADE support)
3. **Builds Strecs3D** against these dependencies
4. **Packages as a Flatpak** with desktop integration:
   - Desktop file, icon, and metainfo (with screenshot)
   - X11 + Wayland + OpenGL access
   - User home directory access for 3D model files

## CI

The GitHub Actions workflow in `.github/workflows/build-flatpak.yml`:
- Builds the flatpak on pushes and PRs
- Uploads the `.flatpak` bundle as an artifact (30-day retention)
- Creates a release on version tags

## Files

| File | Description |
|------|-------------|
| `com.github.tomohiron907.Strecs3D.yml` | Flatpak manifest (9 modules) |
| `Makefile` | Build helpers (`make build`/`install`/`run`) |
| `.github/workflows/build-flatpak.yml` | CI workflow |
| `patches/0001-add-linux-support.patch` | Linux porting patch |

## Notes

- All commit hashes in the manifest have been verified against their git tags
- VTK commit hash was corrected from an invalid value to match tag v9.3.1
- GMSH generates a cmake config at build time for `find_package(gmsh CONFIG)`
- OCCT uses its default cmake install path (`lib/cmake/opencascade/`) — no override needed
- The forced `QT_QPA_PLATFORM=xcb` env was removed to let Qt auto-detect Wayland/X11
- Cleanup removes build-time artifacts (headers, cmake configs, docs) from final bundle
