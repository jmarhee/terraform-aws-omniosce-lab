#!/bin/bash

install_pkgsrc() {
	echo "Installing Pkgsrc..."
	BOOTSTRAP_TAR="bootstrap-trunk-x86_64-20190317.tar.gz"
	BOOTSTRAP_SHA="cda0f6cd27b2d8644e24bc54d19e489d89786ea7"
	curl -O https://pkgsrc.joyent.com/packages/SmartOS/bootstrap/$BOOTSTRAP_TAR
	[ "$BOOTSTRAP_SHA" = "$(/bin/digest -a sha1 $BOOTSTRAP_TAR)" ] || echo "ERROR: checksum failure"
	curl -O https://pkgsrc.joyent.com/packages/SmartOS/bootstrap/$BOOTSTRAP_TAR.asc
	curl -sS https://pkgsrc.joyent.com/pgp/DE817B8E.asc
	tar -zxpf $BOOTSTRAP_TAR -C /
}

install_dev_tools() {
	echo "Installing Dev Tools..."
	PATH=/opt/local/sbin:/opt/local/bin:$PATH \
	MANPATH=/opt/local/man:$MANPATH \
	sudo pkg install pkg:/developer/illumos-tools ; \
	sudo pkg install git
}

clone_gate() {
	echo "Cloning illumos-gate"
	mkdir /code ; \
	cd /code ; \
	git clone https://github.com/illumos/illumos-gate.git
	echo "illumos-gate cloned to /code/illumos-gate..."
}

install_pkgsrc ; \
install_dev_tools ; \
clone_gate
