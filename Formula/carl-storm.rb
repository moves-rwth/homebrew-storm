class CarlStorm < Formula
  desc "Computer ARithmetic and Logic library for the probabilistic model checker Storm"
  homepage "https://github.com/moves-rwth/carl-storm/"
  # version is extracted from url
  url "https://github.com/moves-rwth/carl-storm/archive/refs/tags/14.27.tar.gz"
  sha256 "7c43d1d125ce4c1b05d0f06b7a47950b83b6c2d6331d85580c06582bd1d18f84"
  license "MIT"

  head "https://github.com/moves-rwth/carl-storm.git", branch: "master", using: :git

  depends_on "boost"
  depends_on "cmake"
  depends_on "eigen"
  depends_on "gmp"
  on_intel do
    depends_on "cln" => :optional
    depends_on "ginac" => :optional
  end

  def install
    args = %w[
      -DEXPORT_TO_CMAKE=OFF
      -DCMAKE_BUILD_TYPE=RELEASE
      -DEXCLUDE_TESTS_FROM_ALL=ON
      -DTHREAD_SAFE=ON
    ]
    args << "-DUSE_CLN_NUMBERS=ON" if build.with?("cln") && Hardware::CPU.intel?
    args << "-DUSE_GINAC=ON" if build.with?("ginac") && Hardware::CPU.intel?
    args << "-DUSE_CLN_NUMBERS=OFF -DUSE_GINAC=OFF" if Hardware::CPU.arm?

    mktemp do
      system "cmake", buildpath, *(std_cmake_args + args)
      system "make", "install"
    end
  end
end
