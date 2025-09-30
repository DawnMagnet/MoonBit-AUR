pkgname=moonbit-bin
pkgver=$(./get_version.sh)
pkgrel=1
pkgdesc="Intelligent developer platform for Cloud and Edge using WASM"
arch=('x86_64')
url="https://www.moonbitlang.com/"
license=('unknown')
depends=('tar' 'glibc' 'gcc-libs' 'git')
provides=("moonbit")
conflicts=("moonbit")
options=('!debug')
_origin="https://cli.moonbitlang.com"
source=("https://cli.moonbitlang.cn/binaries/latest/moonbit-linux-x86_64.tar.gz"
        "https://cli.moonbitlang.cn/cores/core-latest.tar.gz"
        "moon.sh"
        "get_version.sh"
        "get_sha256sums.sh")
sha256sums=($(./get_sha256sums.sh) 'SKIP' 'SKIP' 'SKIP')
package() {
  install -Dm 755 "${srcdir}/bin/moon"     "${pkgdir}/usr/lib/moon"
  install -Dm 755 "${srcdir}/moon.sh"  "${pkgdir}/usr/bin/moon"
  install -Dm 755 "${srcdir}/bin/moonc"    "${pkgdir}/usr/bin/moonc"
  install -Dm 755 "${srcdir}/bin/moondoc"  "${pkgdir}/usr/bin/moondoc"
  install -Dm 755 "${srcdir}/bin/moonfmt"  "${pkgdir}/usr/bin/moonfmt"
  install -Dm 755 "${srcdir}/bin/moonrun"  "${pkgdir}/usr/bin/moonrun"
  mkdir -p "${pkgdir}/usr/share/moonbit/lib"
  cp -r "${srcdir}/core" "${pkgdir}/usr/share/moonbit/lib/"
}
