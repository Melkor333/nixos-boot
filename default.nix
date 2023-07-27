{
  pkgs ? import <nixpkgs> {},
  theme ? "load_unload",
  bgColor ? "255, 255, 255", # rgb value between 0-1. TODO: Write hex to plymouth magic
}:
pkgs.stdenv.mkDerivation rec {
  pname = "nixos-boot-${theme}";
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
    # Set the Background Color
    sed -i 's/\(Window\.SetBackground[^ ]*\).*/\1 (${bgColor});/' "${theme}/"*script
  '';

  installPhase = ''
    cd ${theme}
    cp -r *png $out/share/plymouth/themes/nixos_boot
    cp -r nixos_boot.script $out/share/plymouth/themes/nixos_boot
    cp -r nixos_boot.plymouth $out/share/plymouth/themes/nixos_boot
    chmod +x $out/share/plymouth/themes/nixos_boot/nixos_boot.plymouth $out/share/plymouth/themes/nixos_boot/nixos_boot.script
    find $out/share/plymouth -name "*.plymouth" -exec sed -i "s@\/usr\/@$out\/@" {} \;
  '';
}
