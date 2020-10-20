APPNAME = reveries
VERSION = $(shell git describe --always --dirty 2>/dev/null || echo -n 'v0.1-git')
PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin
BASHCOMPDIR ?= $(PREFIX)/share/bash-completion/completions

all:
	@echo "$(APPNAME) is a shell script, no need for compiling. Try \`make install\` instead."

install-completion:
	@install -v -d "$(DESTDIR)$(BASHCOMPDIR)" && install -m 0644 -v completion/reveries.bash-completion "$(DESTDIR)$(BASHCOMPDIR)/reveries"

install: install-completion
	@sed 's/^VERSION=.*$$/VERSION=$(VERSION)/' reveries.sh > reveries
	@install -v -d "$(DESTDIR)$(BINDIR)/" && install -m 0755 -v reveries "$(DESTDIR)$(BINDIR)/reveries"

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(BINDIR)/reveries" \
		"$(DESTDIR)$(BASHCOMPDIR)/reveries"

clean:
	@rm -rf reveries

.PHONY: install install-completion uninstall clean
