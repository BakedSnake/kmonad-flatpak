PREFIX=/usr/local
INSTALL_DIR=$(PREFIX)/bin
CONFIG_PREFIX=/root/.config
CONFIG_DIR=$(CONFIG_PREFIX)/kmonad

config:
	./configure.sh

install:
	mkdir -p $(CONFIG_DIR)
	install -m 0644 *.conf $(CONFIG_DIR)
	flatpak-builder --force-clean --ccache --jobs 4 --install --delete-build-dirs ./build com.github.kmonad.Kmonad.yml
	install -m 0755 kmonad $(INSTALL_DIR)

clean:
	rm -f $(INSTALL_DIR)/kmonad
