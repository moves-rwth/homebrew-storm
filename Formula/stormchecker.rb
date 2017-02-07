class Stormchecker < Formula
  desc "Probabilistic Model Checker"
  homepage "https://moves-rwth.github.io/storm/"
  url "https://github.com/moves-rwth/storm/archive/master.tar.gz"
  version "0.10.1"
  sha256 "592914aee8ada100be7796f6721813bb07c6c50a4fc436807722112ee7b78a73"
  head "https://github.com/moves-rwth/storm.git", :using => :git

  option "with-single-thread", "Build storm using just one thread."
  option "with-tbb", "Build storm with Intel Thread Building Blocks (TBB) support."

  depends_on :macos => :mavericks
  depends_on "cmake"
  depends_on "boost"
  depends_on "z3"
  depends_on "glpk"
  depends_on "cln"
  depends_on "ginac"
  depends_on "automake"
  depends_on "xerces-c"
  depends_on "tbb" => [:optional, "c++11"]

  def install
    ENV.deparallelize  # if your formula fails when building in parallel

    args = %w[
      -DSTORM_DEVELOPER=OFF
      -DSTORM_FORCE_SHIPPED_CARL=ON
      -DSTORM_USE_LTO=ON
    ]
    args << "-DCMAKE_BUILD_TYPE=RELEASE"
    args << "-DSTORM_VERSION_MAJOR=0"
    args << "-DSTORM_VERSION_MINOR=9"
    args << "-DSTORM_VERSION_PATCH=0"
    args << "-DSTORM_SOURCE=archive"

    if build.with?("tbb")
      depends_on "tbb" => %w{c++11}
      args << "-DSTORM_USE_INTELTBB=ON"
    end

    thread_count = Hardware::CPU.cores
    thread_count = 1 if build.with?("single-thread")

    mktemp do
      system "cmake", buildpath, *(std_cmake_args + args)
      system "make", "-j#{thread_count}", "install"
    end
  end

  test do
    shell_output("#{bin}/storm", 1)
  end
end
