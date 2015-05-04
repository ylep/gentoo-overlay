# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CMAKE_MIN_VERSION=2.8
inherit cmake-multilib

DESCRIPTION="I/O libraries for the NIfTI-1 data format"
HOMEPAGE="http://niftilib.sourceforge.net/"
SRC_URI="mirror://sourceforge/niftilib/${P}.tar.gz
test? ( http://nifti.nimh.nih.gov/pub/dist/data/nifti_regress_data.tgz )
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fslio test"

COMMON_DEPEND="sys-libs/zlib[${MULTILIB_USEDEP}]"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

DOCS=(README Updates.txt)

src_prepare() {
	# Request the behaviour of CMake 2.8 (tested version) and set the
	# correct library directory for multilib build
	sed -i -e '1i cmake_minimum_required(VERSION 2.8)' \
		   -e 's/SET(NIFTI_INSTALL_LIB_DIR.*)/SET(NIFTI_INSTALL_LIB_DIR "${CMAKE_INSTALL_LIBDIR}")/' CMakeLists.txt \
		|| die 'could not patch CMakeLists.txt'

	# Fix undefined references
	sed -i '/^ADD_LIBRARY(\${NIFTI_CDFLIB_NAME}.*)/a TARGET_LINK_LIBRARIES(${NIFTI_CDFLIB_NAME} -lm)' \
		nifticdf/CMakeLists.txt \
		|| die 'could not patch nifticdf/CMakeLists.txt'

	# Fetch the test data with Portage instead of at build time
	sed -i 's|^if wget -nd http://nifti.nimh.nih.gov/pub/dist/data/nifti_regress_data.tgz$|if cp "${DISTDIR}"/nifti_regress_data.tgz .|' \
		Testing/nifti_regress_test/cmake_testscripts/fetch_data_test.sh \
		|| die 'could not patch fetch_data_test.sh'
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		$(cmake-utils_use fslio USE_FSL_CODE)
	)
	cmake-utils_src_configure
}
