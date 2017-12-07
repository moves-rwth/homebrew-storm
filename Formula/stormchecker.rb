class Stormchecker < Formula
  desc "A modern probabilistic model checker."
  homepage "http://www.stormchecker.org"
  url "https://github.com/moves-rwth/storm/archive/1.2.0.zip"
  version "1.2.0"
  sha256 "8eb557b3ded3a3edc2a9069c467db7f838008fad72f6cc75e0b84a8d8979ecc8"
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
  depends_on "moves-rwth/misc/cocoalib"
  depends_on "moves-rwth/misc/carl" => ["with-thread-safe", "with-cln", "with-ginac"]

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
