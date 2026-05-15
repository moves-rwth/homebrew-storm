class Stormchecker < Formula
  desc "Modern probabilistic model checker"
  homepage "https://www.stormchecker.org"
  url "https://github.com/stormchecker/storm/archive/refs/tags/1.13.0.tar.gz"
  sha256 "0d87f5ec0bf7295bc859134a11118444100978f1e3c49aed87ce41cb5f0a7ae5"
  license "GPL-3.0-only"
  head "https://github.com/stormchecker/storm.git", using: :git, branch: "master"

  bottle do
    root_url "https://github.com/moves-rwth/homebrew-storm/releases/download/stormchecker-1.13.0"
    sha256 cellar: :any,                 arm64_tahoe:   "8cb9384e08b2fedf0f7248e67aff657a551d67b8e39656975e4e13d8c662c988"
    sha256 cellar: :any,                 arm64_sequoia: "3971d9a0719882e90972fb7d4808fc65bb53ea4f01c40769890b5a3fc2cff2a6"
    sha256 cellar: :any,                 arm64_sonoma:  "3c175a62a2c6523d7517686a6562e1b71942a70cdbe9e402c19bf9fd92d72f7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccc22618bed8965ffcab8769883b8c93c21179fa53ea713b7d77c0fdfcf5a205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7079b7672c30f1092b706efd476861409fce12bcbdfda2c608f6a835437d6e48"
  end

  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cln"
  depends_on "ginac"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "hwloc"
  depends_on "libarchive"
  depends_on "spot"
  depends_on "xerces-c"
  depends_on "z3"

  # Additional dependencies (usually obtained via FetchContent)
  resource "carl-storm" do
    url "https://github.com/stormchecker/carl-storm/archive/refs/tags/14.35.tar.gz"
    sha256 "709eb094f4ec21e9d624915dfe94bb8b9a5e5f19d97a14824b471696f6f41857"
  end

  def install
    # Stage resources
    (buildpath/"fetched_deps").mkpath
    resources.each do |r|
      r.stage buildpath/"fetched_deps"/r.name
    end

    # Set CMake flags
    args = %w[
      -DCMAKE_BUILD_TYPE=RELEASE
      -DSTORM_COMPILE_WITH_CCACHE=OFF
      -DSTORM_BUILD_TESTS=OFF
      -DFETCHCONTENT_SOURCE_DIR_CARL=fetched_deps/carl-storm
      -DFETCHCONTENT_SOURCE_DIR_SYLVANFETCH=resources/3rdparty/sylvan
    ]

    # Build and install
    system "cmake", "-S", ".", "-B", "build", *(std_cmake_args + args)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Write small MDP file
    (testpath/"walk.nm").write <<~EOS
      mdp
      const int N;
      const double p = 0.5;
      module main
              x : [0..N] init N/2;
              [right] x<N -> p : (x'=x+1) + (1-p) : (x'=x);
              [left] x>0 -> p : (x'=x-1) + (1-p) : (x'=x);
      endmodule
    EOS
    # Run Storm and check output
    output = shell_output("#{bin}/storm --prism #{testpath}/walk.nm -prop 'Pmax=? [F<=10 x=0]' -const 'N=10' --exact")
    assert_match "Result (for initial states): 319/512", output
  end
end
