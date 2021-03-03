APPNAME = tfw
VERSION = $(shell git describe --long --always --dirty 2>/dev/null || echo -n 'v0.1-git')
PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin
BASHCOMPDIR ?= $(PREFIX)/share/bash-completion/completions

all:
	@echo "$(APPNAME) is a shell script, no need for compiling. Try \`make install\` instead."

install-completion:
	@install -v -d "$(DESTDIR)$(BASHCOMPDIR)" && install -m 0644 -v completion/$(APPNAME).bash-completion "$(DESTDIR)$(BASHCOMPDIR)/$(APPNAME)"

install: install-completion
	@sed 's/^VERSION=.*$$/VERSION=$(VERSION)/' $(APPNAME).sh > $(APPNAME)
	@install -v -d "$(DESTDIR)$(BINDIR)/" && install -m 0755 -v $(APPNAME) "$(DESTDIR)$(BINDIR)/$(APPNAME)"

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(BINDIR)/$(APPNAME)" \
		"$(DESTDIR)$(BASHCOMPDIR)/$(APPNAME)"

clean:
	@rm -rf $(APPNAME)

.PHONY: install install-completion uninstall clean
