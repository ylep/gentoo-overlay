# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils versionator

MY_PV=$(replace_all_version_separators -)

DESCRIPTION="Basic tools for the MINC medical imaging file format"
HOMEPAGE="https://github.com/BIC-MNI/${PN}"
SRC_URI="https://github.com/BIC-MNI/${PN}/archive/${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# The build fails at compile time if minc.h is not present (i.e. if
# minc1 support is disabled in libminc)
RDEPEND="
>=sci-libs/libminc-2.3.00[minc1]
!sci-misc/minc
"
DEPEND="${RDEPEND}
sys-devel/bison
sys-devel/flex
"

src_install() {
	cmake-utils_src_install

	# Move man pages from the deprecated /usr/man into /usr/share/man
	mkdir -p "${D}"/usr/share
	mv "${D}"/usr/man "${D}"/usr/share/man
}
