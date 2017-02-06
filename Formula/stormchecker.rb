class Stormchecker < Formula
  desc "Probabilistic Model Checker"
  homepage "https://moves-rwth.github.io/storm/"
  url "https://github.com/moves-rwth/storm/archive/master.tar.gz"
  version "0.10.1"
  sha256 "152b2bff3eb567d904da7843b25b206dd1549933a1d50db6670ba9c6d7631a83"

  depends_on "cmake"
  depends_on "boost"
  depends_on "z3"
  depends_on "glpk"
  depends_on "cln"
  depends_on "ginac"
  depends_on "automake"

  def install
    ENV.deparallelize  # if your formula fails when building in parallel

    system "cmake", ".", "-DSTORM_DEVELOPER=OFF", "-DCMAKE_BUILD_TYPE=RELEASE", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DSTORM_FORCE_SHIPPED_CARL=ON", "-DSTORM_SOURCE=archive", "-DSTORM_CPP_VERSION_MAJOR=0", "-DSTORM_CPP_VERSION_MINOR=9", "-DSTORM_CPP_VERSION_PATCH=0"
    system "make", "-j#{ENV.make_jobs}", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test homebrew-storm`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
