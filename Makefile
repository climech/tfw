APPNAME = tfw
VERSION = $(shell git describe --long --always --dirty 2>/dev/null || echo -n 'v0.1.1')
PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin
BASHCOMPDIR ?= $(PREFIX)/share/bash-completion/completions

all: build

build: $(APPNAME)
	
$(APPNAME): $(APPNAME).sh
	@sed 's/^VERSION=.*$$/VERSION=$(VERSION)/' $(APPNAME).sh > $(APPNAME)
	@chmod +x $(APPNAME)

install-completion:
	@install -v -d "$(DESTDIR)$(BASHCOMPDIR)" && install -m 0644 -v completion/$(APPNAME).bash-completion "$(DESTDIR)$(BASHCOMPDIR)/$(APPNAME)"

install: build install-completion
	@install -v -d "$(DESTDIR)$(BINDIR)/" && install -m 0755 -v $(APPNAME) "$(DESTDIR)$(BINDIR)/$(APPNAME)"

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(BINDIR)/$(APPNAME)" \
		"$(DESTDIR)$(BASHCOMPDIR)/$(APPNAME)"

clean:
	@rm -rf $(APPNAME)

.PHONY: install-completion clean uninstall
