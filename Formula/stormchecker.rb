class Stormchecker < Formula
  desc "A modern probabilistic model checker"
  homepage "http://www.stormchecker.org"
  url "https://github.com/moves-rwth/storm/archive/1.4.1.zip"
  version "1.4.1"
  sha256 "625a03b8a21c1dd914d0453b1945f785e9fc8a6da13a50c82ad55ac8a00106ee"
  head "https://github.com/moves-rwth/storm.git", :using => :git

  # option "with-single-thread", "Build Storm using just one thread."
  option "with-tbb", "Build Storm with Intel Thread Building Blocks (TBB) support."
  option "with-cocoalib", "Build with support for CoCoALib (also requires CArl to be built with support for CoCoALib)."

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "z3"
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "xerces-c"
  depends_on "tbb" if build.with?("tbb")
  depends_on "glpk"
  depends_on "hwloc"
  depends_on "doxygen"
  depends_on "moves-rwth/misc/cocoalib" if build.with?("cocoalib")
  depends_on "moves-rwth/misc/carl" => build.with?("cocoalib") ? ["with-thread-safe", "with-cln", "with-ginac", "with-cocoalib"] : ["with-thread-safe", "with-cln", "with-ginac"]

  def install
    args = %w[
      -DSTORM_DEVELOPER=OFF
      -DCMAKE_BUILD_TYPE=RELEASE
      -DSTORM_COMPILE_WITH_CCACHE=OFF
    ]
    args << "-DSTORM_USE_INTELTBB=ON" if build.with?("tbb")

    mktemp do
      system "cmake", buildpath, *(std_cmake_args + args)
      system "make", "install"
    end
  end

  test do
    shell_output("#{bin}/storm", 1)
  end
end
