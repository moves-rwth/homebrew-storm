class Stormchecker < Formula
  desc "Probabilistic Model Checker"
  homepage "https://moves-rwth.github.io/storm/"
  url "https://github.com/moves-rwth/storm/archive/1.0.0.tar.gz"
  version "1.0.0"
  sha256 "679838a44392138159433e5fd084d8aa3bcc241d3a299f02ac4b89eb66ee8595"
  head "https://github.com/moves-rwth/storm.git", :using => :git

  option "with-single-thread", "Build storm using just one thread."
  option "with-tbb", "Build storm with Intel Thread Building Blocks (TBB) support."

  depends_on :macos => :mavericks
  depends_on "cmake"
  depends_on "boost"
  depends_on "z3"
  depends_on "cln"
  depends_on "ginac"
  depends_on "automake"
  depends_on "xerces-c"
  depends_on "tbb" => [:optional, "c++11"]
  depends_on "homebrew/science/glpk"

  def install
    ENV.deparallelize  # if your formula fails when building in parallel

    args = %w[
      -DSTORM_DEVELOPER=OFF
      -DSTORM_FORCE_SHIPPED_CARL=ON
      -DSTORM_USE_LTO=ON
    ]
    args << "-DCMAKE_BUILD_TYPE=RELEASE"

    if build.with?("tbb")
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
