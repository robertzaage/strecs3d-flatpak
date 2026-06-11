.PHONY: all build install clean test-bundle

all: build

# Build the flatpak (requires flatpak-builder and the KDE SDK)
build:
	flatpak-builder --force-clean \
		--ccache \
		--install-deps-from=flathub \
		build-dir \
		com.github.tomohiron907.Strecs3D.yml

# Install the built flatpak locally
install:
	flatpak-builder --user --install \
		--force-clean \
		--ccache \
		--install-deps-from=flathub \
		build-dir \
		com.github.tomohiron907.Strecs3D.yml

# Create a bundle (.flatpak) for distribution
bundle:
	flatpak build-bundle \
		/var/lib/flatpak/repo \
		Strecs3D.flatpak \
		com.github.tomohiron907.Strecs3D

# Clean build artifacts
clean:
	rm -rf build-dir .flatpak-builder

# Run the application to test
run:
	flatpak run com.github.tomohiron907.Strecs3D

# Export to a local repo for testing
repo:
	flatpak-builder --repo=local-repo \
		--force-clean \
		--ccache \
		--install-deps-from=flathub \
		build-dir \
		com.github.tomohiron907.Strecs3D.yml
