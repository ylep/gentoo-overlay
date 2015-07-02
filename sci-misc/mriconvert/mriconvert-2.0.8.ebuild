# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WX_GTK_VER=3.0
CMAKE_MIN_VERSION=2.8.2
inherit cmake-utils wxwidgets versionator

MY_V=$(replace_all_version_separators -)
DESCRIPTION="medical image file conversion utility"
HOMEPAGE="http://lcni.uoregon.edu/~jolinda/MRIConvert/"
SRC_URI="http://lcni.uoregon.edu/downloads/mriconvert/mriconvert-${MY_V}-source-tarball -> ${P}.tar.gz"

# From the homepage: "All LCNI software is available free of charge
# under the GNU General Public License (GPL)."
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="
>=x11-libs/wxGTK-3.0:${WX_GTK_VER}[X]
>=dev-libs/libutf8proc-1.1.6
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}/${PV}-unbundle-libutf8proc.patch"
}

src_configure() {
	# There is no point in making the GUI optional because the
	# command-line (mcverter) depends on wxCore (i.e. x11-libs/wxGTK[X])

	local mycmakeargs=(
		-DwxWidgets_CONFIG_EXECUTABLE="${WX_CONFIG}"
	)
	cmake-utils_src_configure
}

src_install() {
	cd "${BUILD_DIR}"/release || die
	dobin mcverter
	dobin MRIConvert
}
