#!/usr/bin/env bash

set -e

if [ "$#" -ne 1 ]; then
    echo "Syntax: $0 <output directory>"
    exit 1
fi

SCRIPTDIR=$(realpath $(dirname "${BASH_SOURCE[0]}"))
NPROCS="$(getconf _NPROCESSORS_ONLN)"
INSTALLDIR="$1"
if [ "${INSTALLDIR:0:1}" != "/" ]; then
	INSTALLDIR="$PWD/$INSTALLDIR"
fi

LIBBACKTRACE=ad106d5fdd5d960bd33fae1c48a351af567fd075
LIBJPEG=9f
LIBPNG=1.6.44
LIBWEBP=1.4.0
LZ4=b8fd2d15309dd4e605070bd4486e26b6ef814e29
SDL=SDL2-2.30.9
QT=6.8.1
ZSTD=1.5.6

SHADERC=2024.1
SHADERC_GLSLANG=142052fa30f9eca191aa9dcf65359fcaed09eeec
SHADERC_SPIRVHEADERS=5e3ad389ee56fca27c9705d093ae5387ce404df4
SHADERC_SPIRVTOOLS=dd4b663e13c07fea4fbb3f70c1c91c86731099f7

mkdir -p deps-build
cd deps-build

cat > SHASUMS <<EOF
fd6f417fe9e3a071cf1424a5152d926a34c4a3c5070745470be6cf12a404ed79  $LIBBACKTRACE.zip
04705c110cb2469caa79fb71fba3d7bf834914706e9641a4589485c1f832565b  jpegsrc.v$LIBJPEG.tar.gz
60c4da1d5b7f0aa8d158da48e8f8afa9773c1c8baa5d21974df61f1886b8ce8e  libpng-$LIBPNG.tar.xz
61f873ec69e3be1b99535634340d5bde750b2e4447caa1db9f61be3fd49ab1e5  libwebp-$LIBWEBP.tar.gz
0728800155f3ed0a0c87e03addbd30ecbe374f7b080678bbca1506051d50dec3  $LZ4.tar.gz
24b574f71c87a763f50704bbb630cbe38298d544a1f890f099a4696b1d6beba4  $SDL.tar.gz
8c29e06cf42aacc1eafc4077ae2ec6c6fcb96a626157e0593d5e82a34fd403c1  zstd-$ZSTD.tar.gz
40b14562ef3bd779bc0e0418ea2ae08fa28235f8ea6e8c0cb3bce1d6ad58dcaf  qtbase-everywhere-src-$QT.tar.xz
138cc2909aa98f5ff7283e36eb3936eb5e625d3ca3b4febae2ca21d8903dd237  qtimageformats-everywhere-src-$QT.tar.xz
3d0de73596e36b2daa7c48d77c4426bb091752856912fba720215f756c560dd0  qtsvg-everywhere-src-$QT.tar.xz
9d43d409be08b8681a0155a9c65114b69c9a3fc11aef6487bb7fdc5b283c432d  qttools-everywhere-src-$QT.tar.xz
635a6093e99152243b807de51077485ceadd4786d4acb135b9340b2303035a4a  qttranslations-everywhere-src-$QT.tar.xz
2226fbde4e2ddd12f8bf4b239c8f38fd706a54e789e63467dfddc77129eca203  qtwayland-everywhere-src-$QT.tar.xz
eb3b5f0c16313d34f208d90c2fa1e588a23283eed63b101edd5422be6165d528  shaderc-$SHADERC.tar.gz
aa27e4454ce631c5a17924ce0624eac736da19fc6f5a2ab15a6c58da7b36950f  shaderc-glslang-$SHADERC_GLSLANG.tar.gz
5d866ce34a4b6908e262e5ebfffc0a5e11dd411640b5f24c85a80ad44c0d4697  shaderc-spirv-headers-$SHADERC_SPIRVHEADERS.tar.gz
03ee1a2c06f3b61008478f4abe9423454e53e580b9488b47c8071547c6a9db47  shaderc-spirv-tools-$SHADERC_SPIRVTOOLS.tar.gz
EOF

curl -L \
	-O "https://github.com/ianlancetaylor/libbacktrace/archive/$LIBBACKTRACE.zip" \
	-O "https://ijg.org/files/jpegsrc.v$LIBJPEG.tar.gz" \
	-O "https://downloads.sourceforge.net/project/libpng/libpng16/$LIBPNG/libpng-$LIBPNG.tar.xz" \
	-O "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-$LIBWEBP.tar.gz" \
	-O "https://github.com/lz4/lz4/archive/$LZ4.tar.gz" \
	-O "https://libsdl.org/release/$SDL.tar.gz" \
	-O "https://github.com/facebook/zstd/releases/download/v$ZSTD/zstd-$ZSTD.tar.gz" \
	-O "https://download.qt.io/official_releases/qt/${QT%.*}/$QT/submodules/qtbase-everywhere-src-$QT.tar.xz" \
	-O "https://download.qt.io/official_releases/qt/${QT%.*}/$QT/submodules/qtimageformats-everywhere-src-$QT.tar.xz" \
	-O "https://download.qt.io/official_releases/qt/${QT%.*}/$QT/submodules/qtsvg-everywhere-src-$QT.tar.xz" \
	-O "https://download.qt.io/official_releases/qt/${QT%.*}/$QT/submodules/qttools-everywhere-src-$QT.tar.xz" \
	-O "https://download.qt.io/official_releases/qt/${QT%.*}/$QT/submodules/qttranslations-everywhere-src-$QT.tar.xz" \
	-O "https://download.qt.io/official_releases/qt/${QT%.*}/$QT/submodules/qtwayland-everywhere-src-$QT.tar.xz" \
	-o "shaderc-$SHADERC.tar.gz" "https://github.com/google/shaderc/archive/refs/tags/v$SHADERC.tar.gz" \
	-o "shaderc-glslang-$SHADERC_GLSLANG.tar.gz" "https://github.com/KhronosGroup/glslang/archive/$SHADERC_GLSLANG.tar.gz" \
	-o "shaderc-spirv-headers-$SHADERC_SPIRVHEADERS.tar.gz" "https://github.com/KhronosGroup/SPIRV-Headers/archive/$SHADERC_SPIRVHEADERS.tar.gz" \
	-o "shaderc-spirv-tools-$SHADERC_SPIRVTOOLS.tar.gz" "https://github.com/KhronosGroup/SPIRV-Tools/archive/$SHADERC_SPIRVTOOLS.tar.gz"

shasum -a 256 --check SHASUMS

echo "Building libbacktrace..."
rm -fr "libbacktrace-$LIBBACKTRACE"
unzip "$LIBBACKTRACE.zip"
cd "libbacktrace-$LIBBACKTRACE"
./configure --prefix="$INSTALLDIR"
make
make install
cd ..

echo "Building libpng..."
rm -fr "libpng-$LIBPNG"
tar xf "libpng-$LIBPNG.tar.xz"
cd "libpng-$LIBPNG"
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALLDIR" -DCMAKE_INSTALL_PREFIX="$INSTALLDIR" -DBUILD_SHARED_LIBS=ON -DBUILD_SHARED_LIBS=ON -DPNG_TESTS=OFF -DPNG_STATIC=OFF -DPNG_SHARED=ON -DPNG_TOOLS=OFF -B build -G Ninja
cmake --build build --parallel
ninja -C build install
cd ..

echo "Building libjpeg..."
rm -fr "jpeg-$LIBJPEG"
tar xf "jpegsrc.v$LIBJPEG.tar.gz"
cd "jpeg-$LIBJPEG"
mkdir build
cd build
../configure --prefix="$INSTALLDIR" --disable-static --enable-shared
make "-j$NPROCS"
make install
cd ../..

echo "Building LZ4..."
rm -fr "lz4-$LZ4"
tar xf "$LZ4.tar.gz"
cd "lz4-$LZ4"
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALLDIR" -DCMAKE_INSTALL_PREFIX="$INSTALLDIR" -DBUILD_SHARED_LIBS=ON -DLZ4_BUILD_CLI=OFF -DLZ4_BUILD_LEGACY_LZ4C=OFF -B build-dir -G Ninja build/cmake
cmake --build build-dir --parallel
ninja -C build-dir install
cd ..

echo "Building Zstandard..."
rm -fr "zstd-$ZSTD"
tar xf "zstd-$ZSTD.tar.gz"
cd "zstd-$ZSTD"
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALLDIR" -DCMAKE_INSTALL_PREFIX="$INSTALLDIR" -DBUILD_SHARED_LIBS=ON -DZSTD_BUILD_SHARED=ON -DZSTD_BUILD_STATIC=OFF -DZSTD_BUILD_PROGRAMS=OFF -B build -G Ninja build/cmake
cmake --build build --parallel
ninja -C build install
cd ..

echo "Building WebP..."
rm -fr "libwebp-$LIBWEBP"
tar xf "libwebp-$LIBWEBP.tar.gz"
cd "libwebp-$LIBWEBP"
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALLDIR" -DCMAKE_INSTALL_PREFIX="$INSTALLDIR" -B build -G Ninja \
  -DWEBP_BUILD_ANIM_UTILS=OFF -DWEBP_BUILD_CWEBP=OFF -DWEBP_BUILD_DWEBP=OFF -DWEBP_BUILD_GIF2WEBP=OFF -DWEBP_BUILD_IMG2WEBP=OFF \
  -DWEBP_BUILD_VWEBP=OFF -DWEBP_BUILD_WEBPINFO=OFF -DWEBP_BUILD_WEBPMUX=OFF -DWEBP_BUILD_EXTRAS=OFF -DBUILD_SHARED_LIBS=ON
cmake --build build --parallel
ninja -C build install
cd ..

echo "Building SDL..."
rm -fr "$SDL"
tar xf "$SDL.tar.gz"
cd "$SDL"
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALLDIR" -DCMAKE_INSTALL_PREFIX="$INSTALLDIR" -DBUILD_SHARED_LIBS=ON -DSDL_SHARED=ON -DSDL_STATIC=OFF -G Ninja
cmake --build build --parallel
ninja -C build install
cd ..

# Couple notes:
# -fontconfig is needed otherwise Qt Widgets render only boxes.
# -qt-doubleconversion avoids a dependency on libdouble-conversion.
# ICU avoids pulling in a bunch of large libraries, and hopefully we can get away without it.
# OpenGL is needed to render window decorations in Wayland, apparently.
echo "Building Qt Base..."
rm -fr "qtbase-everywhere-src-$QT"
tar xf "qtbase-everywhere-src-$QT.tar.xz"
cd "qtbase-everywhere-src-$QT"
mkdir build
cd build
../configure -prefix "$INSTALLDIR" -release -dbus-linked -gui -widgets -fontconfig -qt-doubleconversion -ssl -openssl-runtime -opengl desktop -qpa xcb,wayland -xkbcommon -xcb -gtk -- -DFEATURE_dbus=ON -DFEATURE_icu=OFF -DFEATURE_printsupport=OFF -DFEATURE_sql=OFF -DFEATURE_system_png=ON -DFEATURE_system_jpeg=ON -DFEATURE_system_zlib=ON -DFEATURE_system_freetype=ON -DFEATURE_system_harfbuzz=ON
cmake --build . --parallel
ninja install
cd ../../

echo "Building Qt SVG..."
rm -fr "qtsvg-everywhere-src-$QT"
tar xf "qtsvg-everywhere-src-$QT.tar.xz"
cd "qtsvg-everywhere-src-$QT"
mkdir build
cd build
"$INSTALLDIR/bin/qt-configure-module" .. -- -DCMAKE_PREFIX_PATH="$INSTALLDIR"
cmake --build . --parallel
ninja install
cd ../../

echo "Building Qt Image Formats..."
rm -fr "qtimageformats-everywhere-src-$QT"
tar xf "qtimageformats-everywhere-src-$QT.tar.xz"
cd "qtimageformats-everywhere-src-$QT"
mkdir build
cd build
"$INSTALLDIR/bin/qt-configure-module" .. -- -DCMAKE_PREFIX_PATH="$INSTALLDIR" -DFEATURE_system_webp=ON
cmake --build . --parallel
ninja install
cd ../../

echo "Building Qt Wayland..."
rm -fr "qtwayland-everywhere-src-$QT"
tar xf "qtwayland-everywhere-src-$QT.tar.xz"
cd "qtwayland-everywhere-src-$QT"
mkdir build
cd build
"$INSTALLDIR/bin/qt-configure-module" .. -- -DCMAKE_PREFIX_PATH="$INSTALLDIR"
cmake --build . --parallel
ninja install
cd ../../

echo "Installing Qt Tools..."
rm -fr "qttools-everywhere-src-$QT"
tar xf "qttools-everywhere-src-$QT.tar.xz"
cd "qttools-everywhere-src-$QT"
# Force disable clang scanning, it gets very confused.
patch -u configure.cmake <<EOF
--- configure.cmake
+++ configure.cmake
@@ -14,12 +14,12 @@
 # Presumably because 6.0 ClangConfig.cmake files are not good enough?
 # In any case explicitly request a minimum version of 8.x for now, otherwise
 # building with CMake will fail at compilation time.
-qt_find_package(WrapLibClang 8 PROVIDED_TARGETS WrapLibClang::WrapLibClang)
+#qt_find_package(WrapLibClang 8 PROVIDED_TARGETS WrapLibClang::WrapLibClang)
 # special case end

-if(TARGET WrapLibClang::WrapLibClang)
-    set(TEST_libclang "ON" CACHE BOOL "Required libclang version found." FORCE)
-endif()
+#if(TARGET WrapLibClang::WrapLibClang)
+#    set(TEST_libclang "ON" CACHE BOOL "Required libclang version found." FORCE)
+#endif()



EOF

mkdir build
cd build
"$INSTALLDIR/bin/qt-configure-module" .. -- -DCMAKE_PREFIX_PATH="$INSTALLDIR" -DFEATURE_assistant=OFF -DFEATURE_clang=OFF -DFEATURE_designer=ON -DFEATURE_kmap2qmap=OFF -DFEATURE_pixeltool=OFF -DFEATURE_pkg_config=OFF -DFEATURE_qev=OFF -DFEATURE_qtattributionsscanner=OFF -DFEATURE_qtdiag=OFF -DFEATURE_qtplugininfo=OFF
cmake --build . --parallel
ninja install
cd ../../

echo "Installing Qt Translations..."
rm -fr "qttranslations-everywhere-src-$QT"
tar xf "qttranslations-everywhere-src-$QT.tar.xz"
cd "qttranslations-everywhere-src-$QT"
mkdir build
cd build
"$INSTALLDIR/bin/qt-configure-module" .. -- -DCMAKE_PREFIX_PATH="$INSTALLDIR"
cmake --build . --parallel
ninja install
cd ../../

echo "Building shaderc..."
rm -fr "shaderc-$SHADERC"
tar xf "shaderc-$SHADERC.tar.gz"
cd "shaderc-$SHADERC"
cd third_party
tar xf "../../shaderc-glslang-$SHADERC_GLSLANG.tar.gz"
mv "glslang-$SHADERC_GLSLANG" "glslang"
tar xf "../../shaderc-spirv-headers-$SHADERC_SPIRVHEADERS.tar.gz"
mv "SPIRV-Headers-$SHADERC_SPIRVHEADERS" "spirv-headers"
tar xf "../../shaderc-spirv-tools-$SHADERC_SPIRVTOOLS.tar.gz"
mv "SPIRV-Tools-$SHADERC_SPIRVTOOLS" "spirv-tools"
cd ..
patch -p1 < "$SCRIPTDIR/../common/shaderc-changes.patch"
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALLDIR" -DCMAKE_INSTALL_PREFIX="$INSTALLDIR" -DSHADERC_SKIP_TESTS=ON -DSHADERC_SKIP_EXAMPLES=ON -DSHADERC_SKIP_COPYRIGHT_CHECK=ON -B build -G Ninja
cmake --build build --parallel
ninja -C build install
cd ..

echo "Cleaning up..."
cd ..
rm -r deps-build
