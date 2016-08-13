all install:
	install -D src/gcs ${HOME}/bin/gcs
	install -d ${HOME}/.config/gcs/colorthemes
	install -d ${HOME}/.config/gcs/modules
	cp -r src/config/colorthemes/* ${HOME}/.config/gcs/colorthemes
	install -d ${HOME}/.local/share/gcs
	cp -r src/share/* ${HOME}/.local/share/gcs
