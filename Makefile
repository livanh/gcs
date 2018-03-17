prefix=/usr/local

all:

install:
	mkdir -p $(DESTDIR)$(prefix)/bin
	install -D src/gcs $(DESTDIR)$(prefix)/bin/gcs
	install -d $(DESTDIR)$(prefix)/share/gcs/colorthemes
	install -d $(DESTDIR)$(prefix)/share/gcs/modules
	mkdir -p $(DESTDIR)$(prefix)/share/gcs/colorthemes
	cp -u -r src/config/colorthemes/* $(DESTDIR)$(prefix)/share/gcs/colorthemes
	mkdir -p $(DESTDIR)$(prefix)/share/gcs/modules
	cp -u -r src/share/modules/* $(DESTDIR)$(prefix)/share/gcs/modules
	mkdir -p $(DESTDIR)/etc/bash_completion.d
	install -D src/etc/bash_completion.d/gcs $(DESTDIR)/etc/bash_completion.d/gcs

.PHONY: install all

