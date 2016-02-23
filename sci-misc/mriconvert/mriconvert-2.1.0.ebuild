# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER=3.0
CMAKE_MIN_VERSION=2.8.2
inherit cmake-utils wxwidgets versionator

MY_V=$(replace_all_version_separators -)
DESCRIPTION="medical image file conversion utility"
HOMEPAGE="http://lcni.uoregon.edu/~jolinda/MRIConvert/"
SRC_URI="http://lcni.uoregon.edu/downloads/mriconvert/MRIConvert-${PV}-src.tar.gz/at_download/file -> MRIConvert-${PV}-src.tar.gz"

# From the homepage: "All LCNI software is available free of charge
# under the GNU General Public License (GPL)." (version is unspecified)
LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="
>=x11-libs/wxGTK-3.0:${WX_GTK_VER}[X]
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

S=${WORKDIR}

src_configure() {
	# We do not bother making the GUI optional because the command-line
	# (mcverter) depends on wxCore anyway (i.e. x11-libs/wxGTK[X])

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
