class Dartsim5 < Formula
  desc "DART: Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io"
  url "https://github.com/dartsim/dart/archive/v5.1.6.tar.gz"
  sha256 "b3b04a321fed0e63483413cc7a9bea780a0b97b7baacf64a574cc042f612d1e3"
  head "https://github.com/dartsim/dart.git", :branch => "release-5.1"

  option "with-core-only", "Build dart-core only"

  deprecated_option "core-only" => "with-core-only"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "assimp"
  depends_on "boost"
  depends_on "eigen"
  depends_on "dartsim/dart/fcl"
  depends_on "dartsim/dart/libccd"

  depends_on "bullet" => :optional

  depends_on "flann" if build.without? "core-only"
  depends_on "tinyxml" if build.without? "core-only"
  depends_on "tinyxml2" if build.without? "core-only"
  depends_on "ros/deps/urdfdom" if build.without? "core-only"
  depends_on "nlopt" if build.without? "core-only" => :optional
  depends_on "dartsim/dart/ipopt" if build.without? "core-only" => :optional
  depends_on "open-scene-graph" if build.without? "core-only" => :optional

  conflicts_with "dartsim4", :because => "Differing version of the same formula"
  conflicts_with "dartsim6", :because => "Differing version of the same formula"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_CORE_ONLY=True" if build.with? "core-only"
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <dart/dart-core.h>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/eigen3", "-L#{lib}", "-ldart", "-lassimp", "-lc++", "-std=c++11", "-o", "test"
    system "./test"
  end
end
