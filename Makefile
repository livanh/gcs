PREFIX=/usr/local

all install:
	install -D src/gcs ${PREFIX}/bin/gcs
	install -d ${PREFIX}/share/gcs/colorthemes
	install -d ${PREFIX}/share/gcs/modules
	cp -u -r src/config/colorthemes/* ${PREFIX}/share/gcs/colorthemes
	cp -u -r src/share/modules/* ${PREFIX}/share/gcs/modules
	install -D src/etc/bash_completion.d/gcs /etc/bash_completion.d/gcs
