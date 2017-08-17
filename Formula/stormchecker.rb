class Stormchecker < Formula
  desc "A modern probabilistic model checker."
  homepage "https://moves-rwth.github.io/storm/"
  url "https://github.com/moves-rwth/storm/archive/stable.zip"
  version "1.1.0"
  sha256 "2e5f5c5880d7b919b0624ddf087e10c73b9a83462601d36ff7adf40628bdf3f4"
  head "https://github.com/moves-rwth/storm.git", :using => :git

  # option "with-single-thread", "Build Storm using just one thread."
  option "with-tbb", "Build Storm with Intel Thread Building Blocks (TBB) support."

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
  depends_on "moves-rwth/misc/carl" => ["with-thread-safe", "with-cln", "with-ginac", "with-cocoalib"]

  def install
    args = %w[
      -DSTORM_DEVELOPER=OFF
      -DCMAKE_BUILD_TYPE=RELEASE
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
