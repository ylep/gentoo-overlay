# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MIN_VERSION=2.8.8
inherit cmake-utils java-pkg-opt-2

IUSE="+java +native pam server"
REQUIRED_USE="native? ( java )"

DESCRIPTION="VNC (Virtual Network Computing) tuned for 3D and video workloads"
SRC_URI="mirror://sourceforge/turbovnc/${P}.tar.gz"
HOMEPAGE="http://www.turbovnc.org/"

KEYWORDS="~amd64"
LICENSE="GPL-2 MIT"
SLOT="0"

# TODO: media-fonts/ dependencies are from tightvnc, not confirmed
CDEPEND=">=media-libs/libjpeg-turbo-1.3.1[java?]
	pam? ( virtual/pam )
	native? ( x11-libs/libX11 x11-libs/libXext )
	server? (
		x11-libs/libX11
		x11-libs/libxkbfile
		x11-libs/libXext
		x11-libs/libXfont
		x11-libs/libfontenc
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/xtrans
	)
	media-fonts/font-misc-misc"
RDEPEND="${CDEPEND}
	!net-misc/tightvnc
	!net-misc/tigervnc
	java? ( >=virtual/jre-1.6 )
	server? (
		x11-apps/xauth
		x11-apps/xsetroot
		media-fonts/font-cursor-misc
	)"
DEPEND="${CDEPEND}
	java? ( >=virtual/jdk-1.6 )
	server? (
		x11-proto/compositeproto
		x11-proto/damageproto
		x11-proto/bigreqsproto
		x11-proto/xextproto
		x11-proto/xineramaproto
		x11-proto/randrproto
		x11-proto/renderproto
		x11-proto/scrnsaverproto
		x11-proto/xcmiscproto
		x11-proto/xf86bigfontproto
		x11-proto/xf86dgaproto
		x11-proto/xf86vidmodeproto
		x11-proto/fixesproto
		x11-proto/inputproto
		x11-proto/kbproto
		x11-proto/resourceproto
		x11-proto/videoproto
		x11-proto/fontsproto
		x11-proto/xproto
	)"

QA_PREBUILT=/usr/share/${PN}/lib/libturbojpeg.so

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use java TVNC_BUILDJAVA)
		$(cmake-utils_use native TVNC_BUILDNATIVE)
		$(cmake-utils_use server TVNC_BUILDSERVER)
		$(cmake-utils_use pam TVNC_USEPAM)
		-DTJPEG_JAR="${EROOT}"/usr/share/libjpeg-turbo/lib/turbojpeg.jar
		-DTJPEG_JNILIBRARY="${EROOT}"/usr/$(get_libdir)/libturbojpeg.so
		-DTVNC_DOCDIR="${EPREFIX}"/usr/share/doc/${PF}
		-DTVNC_MANDIR="${EPREFIX}"/usr/share/man
		-DTVNC_JAVADIR="${EPREFIX}"/usr/share/${PN}/lib  # Follow dojar convention
		-DTVNC_CONFDIR="${EPREFIX}"/etc
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	echo ED = "${ED}"
	rm -f "${ED}"/usr/README.txt
	rm -f "${ED}"/usr/share/doc/${PF}/LICENSE*.txt
}
