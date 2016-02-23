# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes  # because of build system patches
inherit autotools-multilib

DESCRIPTION="Core library of the MINC medical imaging file format"
HOMEPAGE="http://niftilib.sourceforge.net/"
SRC_URI="http://packages.bic.mni.mcgill.ca/tgz/${P}.tar.gz"

LICENSE="minc"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+acr-nema doc static-libs"

# hdf5 support must be disabled in netcdf because it causes the minc
# library to mis-identify MINC2 files as MINC1 files.
COMMON_DEPEND="
sys-libs/zlib[${MULTILIB_USEDEP}]
>=sci-libs/netcdf-4:=[-hdf5,${MULTILIB_USEDEP}]
>=sci-libs/hdf5-1.8:=[${MULTILIB_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
doc? ( dev-lang/perl )
"
RDEPEND="${COMMON_DEPEND}"

PATCHES=(
	# Patches from the Debian package (version 2.2.00-6)
	"${FILESDIR}"/${P}-maxpathlen.patch
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-acrnema-version.patch
	"${FILESDIR}"/${P}-pod_fix.diff
	"${FILESDIR}"/${P}-clang.patch
	"${FILESDIR}"/${P}-fix-crash-filename-null-voxel-loop.patch
	"${FILESDIR}"/${P}-fix-crash-filename-null.patch

	"${FILESDIR}"/${P}-fix-tests.patch
)

src_prepare() {
	# as per QA warning (#426262)
	mv configure.in configure.ac || die
	autotools-utils_src_prepare
}

multilib_src_configure() {
	# minc2 support is not made optional because the --disable-minc2
	# option is broken, and the library would be crippled anyway without
	# minc2 support.
	local myeconfargs=(
		$(use_enable acr-nema)
	)
	autotools-utils_src_configure
}
