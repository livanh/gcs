prefix=/usr/local

COLORTHEMES := $(subst src/config/colorthemes/, , $(wildcard src/config/colorthemes/*))
MODULES := $(subst src/share/modules/, , $(wildcard src/share/modules/*))

all:

install:
	mkdir -p $(DESTDIR)$(prefix)/bin
	install -D src/gcs $(DESTDIR)$(prefix)/bin/gcs
	install -d $(DESTDIR)$(prefix)/share/gcs/colorthemes
	install -d $(DESTDIR)$(prefix)/share/gcs/modules
	mkdir -p $(DESTDIR)$(prefix)/share/gcs/colorthemes
	for colortheme in $(COLORTHEMES); do \
		if [ -d src/config/colorthemes/$${colortheme} ]; then \
			mkdir -p $(DESTDIR)$(prefix)/share/gcs/colorthemes/$${colortheme}; \
			for file in src/config/colorthemes/$${colortheme}/*; do \
				install $${file} -t $(DESTDIR)$(prefix)/share/gcs/colorthemes/$${colortheme}; \
			done; \
		fi; \
	done;
	mkdir -p $(DESTDIR)$(prefix)/share/gcs/modules
	for module in $(MODULES); do \
		install -m 644 src/share/modules/$${module} -t $(DESTDIR)$(prefix)/share/gcs/modules; \
	done;
	mkdir -p $(DESTDIR)/etc/bash_completion.d
	install -D src/etc/bash_completion.d/gcs $(DESTDIR)/etc/bash_completion.d/gcs

uninstall:
	rm $(DESTDIR)$(prefix)/bin/gcs
	for colortheme in $(COLORTHEMES); do \
		rm -r $(DESTDIR)$(prefix)/share/gcs/colorthemes/$${colortheme}; \
	done;
	for module in $(MODULES); do \
		rm $(DESTDIR)$(prefix)/share/gcs/modules/$${module}; \
	done;
	rm $(DESTDIR)/etc/bash_completion.d/gcs

.PHONY: install uninstall all

