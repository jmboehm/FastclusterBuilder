# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "libfastcluster"
version = v"0.0.1"

# Collection of sources required to build libfastcluster
sources = [
    "http://github.com/jmboehm/Fastcluster.git" =>
    "e36e12f6caef3ded138ee262aa7c1f80b90c8e3c",

]

# Bash recipe for building across all platforms
script = raw"""
if [ $target != "x86_64-apple-darwin14" ]; then
cd $WORKSPACE/srcdir
cd Fastcluster/
./configure --prefix=$prefix --host=$target
make
make install
make clean
cp lib/libfastcluster.so $prefix/libfastcluster.so
exit

if [ $target = "x86_64-apple-darwin14" ]; then
cd $WORKSPACE/srcdir
cd Fastcluster/
./configure --prefix=$prefix --host=$target
make
nano
nano Makefile.in 
./configure --prefix=$prefix --host=$target
make
nano Makefile.in 
./configure --prefix=$prefix --host=$target
make
nano Makefile.in 
./configure --prefix=$prefix --host=$target
make
make install
exit

fi

else
cd $WORKSPACE/srcdir
cd Fastcluster/
sed -i '1d' Makefile.in 
cat Makefile.in 
./configure --prefix=$prefix --host=$target
make
make install
make clean
cp lib/libfastcluster.so $prefix/libfastcluster.so
exit

fi

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libfastcluster", :libfastcluster)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

