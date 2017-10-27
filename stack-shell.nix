{ nixpkgs ? import <nixpkgs> {}
, ghc ? nixpkgs.haskell.compiler.ghc802 }:
let p = nixpkgs; in
let gfortran-lib = p.gcc5.cc.override {
    name = "gfortran";
    langFortran = true;
    langCC = false;
    langC = false;
    profiledCompiler = false;
  };
  jvmlibdir =
    if stdenv.isLinux
    then "${openjdk}/lib/openjdk/jre/lib/amd64/server"
    else "${openjdk}/jre/lib/server";
in
  p.haskell.lib.buildStackProject {
    inherit ghc;
    name = "myEnv";
    buildInputs = [
      p.blas p.liblapack p.pkgconfig p.gsl gfortran-lib
      p.cairo p.glib p.pango p.zlib
      p.git
      p.ghostscript
      p.openjdk p.gradle p.spark p.zlib p.zip
    ];
    extraArgs = ["--extra-lib-dirs=${jvmlibdir}"];
    LD_LIBRARY_PATH = [jvmlibdir];
    hardeningDisable = [ "bindnow" ];
  }
