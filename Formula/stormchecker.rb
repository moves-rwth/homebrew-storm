class Stormchecker < Formula
  desc "A modern probabilistic model checker"
  homepage "https://www.stormchecker.org"
  url "https://github.com/moves-rwth/storm/archive/1.8.1.tar.gz"
  version "1.8.1"
  sha256 "13de6e7816f2b796db3557ac6b058e2ccab9cd129e243cfce93dd7cdd82f3ee1"
  head "https://github.com/moves-rwth/storm.git", using: :git, branch: "master"

  # option "with-single-thread", "Build Storm using just one thread."
  option "with-tbb", "Build Storm with Intel Thread Building Blocks (TBB) support."
  option "with-spot", "Build Storm with Spot (required for LTL model checking)."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "hwloc"
  on_intel do
    depends_on "moves-rwth/misc/carl-storm" => ["with-cln", "with-ginac"]
  end
  on_arm do
    depends_on "moves-rwth/misc/carl-storm"
  end
  depends_on "xerces-c"
  depends_on "z3"
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
