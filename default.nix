{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "nixos-boot";
  version = "0.0.1";

  src = "./";

  buildInputs = [
    pkgs.git
  ];

  configurePhase = ''
    mkdir -p $out/share/plymouth/themes/
  '';

  buildPhase = ''
  '';

  installPhase = ''
    cp -r src $out/share/plymouth/themes/nixos-boot
    find $out/share/plymouth -name "*.plymouth" -exec sed -i "s@\/usr\/@$out\/@" {} \;
  '';
}

