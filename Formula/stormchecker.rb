class Stormchecker < Formula
  desc "Probabilistic Model Checker"
  homepage "https://moves-rwth.github.io/storm/"
  url "https://github.com/moves-rwth/storm/archive/stable.zip"
  version "1.1.0"
  sha256 "b24832b862f67f37802e3d247d426197e91b45e34f52e66cd81628879f8bda98"

  head "https://github.com/moves-rwth/storm.git", :using => :git

  option "with-single-thread", "Build storm using just one thread."
  option "with-tbb", "Build storm with Intel Thread Building Blocks (TBB) support."

  depends_on :macos => :mavericks
  depends_on "cmake"
  depends_on "boost" => ["c++11"]
  depends_on "gmp" => ["c++11"]
  depends_on "z3"
  depends_on "cln"
  depends_on "ginac"
  depends_on "automake"
  depends_on "xerces-c"
  depends_on "tbb" => [:optional, "c++11"]
  depends_on "glpk"
  depends_on "hwloc"

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
