{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "nixos_boot";
  version = "0.0.1";

  src = ./src;

  buildInputs = [
    pkgs.git
  ];

  unpackPhase = ''
  '';

  configurePhase = ''
    mkdir -p $out/share/plymouth/themes/nixos_boot
  '';

  buildPhase = ''
  '';

  installPhase = ''
    cp -r *png $out/share/plymouth/themes/nixos_boot
    cp -r nixos_boot.script $out/share/plymouth/themes/nixos_boot
    cp -r nixos_boot.plymouth $out/share/plymouth/themes/nixos_boot
    chmod +x $out/share/plymouth/themes/nixos_boot/nixos_boot.plymouth $out/share/plymouth/themes/nixos_boot/nixos_boot.script
    find $out/share/plymouth -name "*.plymouth" -exec sed -i "s@\/usr\/@$out\/@" {} \;
  '';
}

