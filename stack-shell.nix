{ nixpkgs ? import (fetchTarball "https://github.com/nixos/nixpkgs/archive/e91840cfb6b7778f8c29d455a2f24cffa1b4e43e.tar.gz") {}
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
    if p.stdenv.isLinux
    then "${p.openjdk}/lib/openjdk/jre/lib/amd64/server"
    else "${p.openjdk}/jre/lib/server";
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
