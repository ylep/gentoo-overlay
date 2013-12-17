# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WX_GTK_VER=2.8
CMAKE_MIN_VERSION=2.8.2
inherit eutils cmake-utils wxwidgets

MY_P=MRIConvert-${PV}
DESCRIPTION="medical image file conversion utility"
HOMEPAGE="http://lcni.uoregon.edu/~jolinda/MRIConvert/"
SRC_URI="http://lcni.uoregon.edu/~jolinda/MRIConvert/${MY_P}-src.tar.gz"
# From the homepage: "All LCNI software is available free of charge
# under the GNU General Public License (GPL)."
LICENSE="GPL-1+"

SLOT="0"
KEYWORDS="~amd64"
IUSE="man"
COMMON_DEPEND="
>=x11-libs/wxGTK-2.8.12:2.8[X]
>=dev-libs/boost-1.52.0
"
DEPEND="${COMMON_DEPEND}
man? ( sys-apps/help2man )
"
RDEPEND="${COMMON_DEPEND}"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}/mriconvert-2.0.6-accept-boost-shared-libs.patch"
}

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	cd "$BUILD_DIR/release" || die
	if use man; then
		help2man --no-info \
			--name='non-interactive MRI conversion software' \
			./mcverter > mcverter.1
	fi
}

src_install() {
	cd "$BUILD_DIR/release" || die
	dobin mcverter
	dobin MRIConvert
	if use man; then
		doman mcverter.1
	fi
}
