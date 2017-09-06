# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils versionator

MY_PV=$(replace_all_version_separators -)

DESCRIPTION="Core library of the MINC medical imaging file format"
HOMEPAGE="https://github.com/BIC-MNI/${PN}"
SRC_URI="https://github.com/BIC-MNI/${PN}/archive/${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+minc1"

# hdf5 support must be disabled in netcdf because it causes the minc
# library to mis-identify MINC2 files as MINC1 files.
DEPEND="
sys-libs/zlib
minc1? ( >=sci-libs/netcdf-4:=[-hdf5] )
>=sci-libs/hdf5-1.8:=
!sci-misc/minc
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-cmake-install-path.patch
)

src_configure() {
	local mycmakeargs=(
		-DLIBMINC_BUILD_SHARED_LIBS=ON
		-DLIBMINC_MINC1_SUPPORT="$(usex minc1 ON OFF)"
	)
	cmake-utils_src_configure
}
