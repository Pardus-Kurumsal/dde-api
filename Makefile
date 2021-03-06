PREFIX = /usr
GOBUILD_DIR = gobuild
GOPKG_PREFIX = pkg.deepin.io/dde/api
GOSITE_DIR = ${PREFIX}/share/gocode
libdir = /lib
SYSTEMD_LIB_DIR = ${libdir}
SYSTEMD_SERVICE_DIR = ${SYSTEMD_LIB_DIR}/systemd/system/

ifndef USE_GCCGO
    GOBUILD = go build
else
    LDFLAGS = $(shell pkg-config --libs gio-2.0 gtk+-3.0 gdk-pixbuf-xlib-2.0 x11 xi xfixes xcursor libcanberra cairo-ft poppler-glib librsvg-2.0)
    GOBUILD = go build -compiler gccgo -gccgoflags "${LDFLAGS}"
endif

LIBRARIES = \
    thumbnails \
    themes \
    dxinput \
    drandr \
    soundutils \
    lang_info \
    i18n_dependent \
    session \
    powersupply

BINARIES =  \
    device \
    graphic \
    locale-helper \
    lunar-calendar \
    mousearea \
    thumbnailer \
    hans2pinyin \
    cursor-helper \
    gtk-thumbnailer \
    sound-theme-player \
    deepin-shutdown-sound \
    image-blur-helper

all: build

prepare:
	@if [ ! -d ${GOBUILD_DIR}/src/${GOPKG_PREFIX} ]; then \
		mkdir -p ${GOBUILD_DIR}/src/$(dir ${GOPKG_PREFIX}); \
		ln -sf ../../../.. ${GOBUILD_DIR}/src/${GOPKG_PREFIX}; \
	fi

out/bin/%:
	env GOPATH="${CURDIR}/${GOBUILD_DIR}:${GOPATH}" ${GOBUILD} -o $@  ${GOPKG_PREFIX}/${@F}

# Install go packages
build-dep:
	go get github.com/disintegration/imaging
	go get github.com/BurntSushi/xgb
	go get github.com/BurntSushi/xgbutil
	go get github.com/howeyc/fsnotify
	go get launchpad.net/gocheck

build: prepare $(addprefix out/bin/, ${BINARIES})

install-binary: build
	mkdir -pv ${DESTDIR}${PREFIX}${libdir}/deepin-api
	cp out/bin/* ${DESTDIR}${PREFIX}${libdir}/deepin-api/

	mkdir -pv ${DESTDIR}${PREFIX}/share/dbus-1/system.d
	cp misc/conf/*.conf ${DESTDIR}${PREFIX}/share/dbus-1/system.d/

	mkdir -pv ${DESTDIR}${PREFIX}/share/dbus-1/services
	cp -v misc/services/*.service ${DESTDIR}${PREFIX}/share/dbus-1/services/

	mkdir -pv ${DESTDIR}${PREFIX}/share/dbus-1/system-services
	cp -v misc/system-services/*.service ${DESTDIR}${PREFIX}/share/dbus-1/system-services/

	mkdir -pv ${DESTDIR}${PREFIX}/share/polkit-1/actions
	cp misc/polkit-action/* ${DESTDIR}${PREFIX}/share/polkit-1/actions/

	#mkdir -pv ${DESTDIR}${PREFIX}/share
	#cp -R misc/dde-api ${DESTDIR}${PREFIX}/share

	mkdir -pv ${DESTDIR}${SYSTEMD_SERVICE_DIR}
	cp -R misc/systemd/system/*.service ${DESTDIR}${SYSTEMD_SERVICE_DIR}

	mkdir -pv ${DESTDIR}${PREFIX}/share/icons/hicolor
	cp -R misc/icons/* ${DESTDIR}${PREFIX}/share/icons/hicolor

build/lib/%:
	env GOPATH="${CURDIR}/${GOBUILD_DIR}:${GOPATH}" ${GOBUILD} ${GOPKG_PREFIX}/${@F}

build-dev: prepare $(addprefix build/lib/, ${LIBRARIES})

install/lib/%:
	mkdir -pv ${DESTDIR}${GOSITE_DIR}/src/${GOPKG_PREFIX}
	cp -R ${CURDIR}/${GOBUILD_DIR}/src/${GOPKG_PREFIX}/${@F} ${DESTDIR}${GOSITE_DIR}/src/${GOPKG_PREFIX}

install-dev: build-dev ${addprefix install/lib/, ${LIBRARIES}}

install: install-binary install-dev

clean:
	rm -rf out/bin gobuild out

rebuild: clean build
