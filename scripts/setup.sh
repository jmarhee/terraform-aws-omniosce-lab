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
	sudo pkg install tmux
}

clone_gate() {
	echo "Cloning illumos-gate"
	mkdir /code ; \
	cd /code ; \
	git clone https://github.com/illumos/illumos-gate.git
	echo "illumos-gate cloned to /code/illumos-gate..."
	echo "Setting ON_CLOSED_BINS"
	echo ON_CLOSED_BINS=/opt/onbld/closed | tee -a /root/.profile
	echo "Copying illumos.sh"
	cd /code/illumos-gate ; cp usr/src/tools/env/illumos.sh .
	echo "Modify /code/illumos-gate/illumos.sh before attempting to build..."
	cat << EOF >> illumos.sh
# Set to the current perl version (this is correct for OmniOS r151028)
export PERL_VERSION=5.28
export PERL_ARCH=i86pc-solaris-thread-multi-64int
export PERL_PKGVERS=
 
# Set to current python3 version (this is correct for OmniOS r151028)
export PYTHON3=/usr/bin/python3.5
export TOOLS_PYTHON=$PYTHON3

export SPRO_ROOT=/opt/sunstudio12.1
export SPRO_VROOT="$SPRO_ROOT"
export ONLY_LINT_DEFS="-I${SPRO_ROOT}/sunstudio12.1/prod/include/lint"
export ON_CLOSED_BINS=/opt/onbld/closed

export __GNUC=
export GNUC_ROOT=/opt/gcc-7/
export PRIMARY_CC=gcc7,/opt/gcc-7/bin/gcc,gnu
export PRIMARY_CCC=gcc7,/opt/gcc-7/bin/g++,gnu
export SHADOW_CCS=gcc4,/opt/gcc-4.4.4/bin/gcc,gnu
export SHADOW_CCCS=gcc4,/opt/gcc-4.4.4/bin/g++,gnu

# This will set ONNV_BUILDNUM to match the release on which you are building, allowing ONU.
export ONNV_BUILDNUM=`grep '^VERSION=r' /etc/os-release | cut -c10-`
export PKGVERS_BRANCH=$ONNV_BUILDNUM.0
EOF
}

install_pkgsrc ; \
install_dev_tools ; \
clone_gate 

echo "To start build, run:\n\n\ttmux new -s illumos-build -d \"cd /code/illumos-gate ; /opt/onbld/bin/nightly illumos.sh || echo \"BUILD FAILED -- CHECK LOGS\"\" \; split-window \"cd /code/illumos-gate; tail -f log/nightly.log\" \; attach\n"