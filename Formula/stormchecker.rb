class Stormchecker < Formula
  desc "Probabilistic Model Checker"
  homepage "https://moves-rwth.github.io/storm/"
  url "https://github.com/moves-rwth/storm/archive/master.tar.gz"
  version "0.10.1"
  sha256 "a64d0f428de180b20e65bfa203ff16fe466f08f246de23743aa5aa83f7faf8ea"

  depends_on "cmake"
  depends_on "boost"
  depends_on "z3"
  depends_on "glpk"
  depends_on "cln"
  depends_on "ginac"
  depends_on "automake"

  def install
    ENV.deparallelize  # if your formula fails when building in parallel

    args = %w[
      -DSTORM_DEVELOPER=OFF
      -DSTORM_FORCE_SHIPPED_CARL=ON
    ]
    args << "-DCMAKE_BUILD_TYPE=RELEASE"
    args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    args << "-DSTORM_VERSION_MAJOR=0"
    args << "-DSTORM_VERSION_MINOR=9"
    args << "-DSTORM_VERSION_PATCH=0"
    args << "-DSTORM_SOURCE=archive"

    system "cmake", ".", *(std_cmake_args + args)
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
