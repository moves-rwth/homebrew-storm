class Stormchecker < Formula
  desc "A modern probabilistic model checker"
  homepage "https://www.stormchecker.org"
  url "https://github.com/moves-rwth/storm/archive/1.6.3.tar.gz"
  version "1.6.3"
  sha256 "e9fb5644b39825a32cc3a125ff571188282b9bd6a32d72097b31118521e2b634"
  head "https://github.com/moves-rwth/storm.git", :using => :git

  # option "with-single-thread", "Build Storm using just one thread."
  option "with-tbb", "Build Storm with Intel Thread Building Blocks (TBB) support."
  option "with-cocoalib", "Build with support for CoCoALib (also requires CArl to be built with support for CoCoALib)."
  option "with-spot", "Build Storm with Spot (required for LTL model checking)."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "doxygen"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "hwloc"
  depends_on "moves-rwth/misc/carl" => build.with?("cocoalib") ? ["with-thread-safe", "with-cln", "with-ginac", "with-cocoalib"] : ["with-thread-safe", "with-cln", "with-ginac"]
  depends_on "xerces-c"
  depends_on "z3"
  depends_on "moves-rwth/misc/cocoalib" => :optional
  depends_on "spot" => :optional
  depends_on "tbb" => :optional

  def install
    args = %w[
      -DSTORM_DEVELOPER=OFF
      -DCMAKE_BUILD_TYPE=RELEASE
      -DSTORM_COMPILE_WITH_CCACHE=OFF
      -DSTORM_EXCLUDE_TESTS_FROM_ALL=ON
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
