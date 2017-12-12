class Stormchecker < Formula
  desc "A modern probabilistic model checker."
  homepage "http://www.stormchecker.org"
  url "https://github.com/moves-rwth/storm/archive/1.2.0.zip"
  version "1.2.0"
  sha256 "1f22850ec6b1c5bf4407ef116ad7da69d7c40194491bf3aaaa944105390d4826"
  head "https://github.com/moves-rwth/storm.git", :using => :git

  # option "with-single-thread", "Build Storm using just one thread."
  option "with-tbb", "Build Storm with Intel Thread Building Blocks (TBB) support."
  option "with-cocoalib", "Build with support for CoCoALib (also requires CArl to be built with support for CoCoALib)."

  depends_on :macos => :mavericks
  depends_on "cmake"
  depends_on "boost" => ["c++11"]
  depends_on "gmp" => ["c++11"]
  depends_on "z3"
  depends_on "automake"
  depends_on "xerces-c"
  depends_on "tbb" => ["c++11"] if build.with?("tbb")
  depends_on "glpk"
  depends_on "hwloc"
  depends_on "moves-rwth/misc/cocoalib" if build.with?("cocoalib")
  depends_on "moves-rwth/misc/carl" => if build.with?("cocoalib") then ["with-thread-safe", "with-cln", "with-ginac", "with-cocoalib"] else ["with-thread-safe", "with-cln", "with-ginac"] end

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
