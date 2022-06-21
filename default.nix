{ config, lib, pkgs, ...}:

{
  nixpkgs.overlays = [ (self: super:
  {
    nixos_boot = super.callPackage ./nixos_boot.nix { };
  }) ];
  boot.plymouth = {
    enable = true;
    themePackages = [ pkgs.nixos_boot ];
    theme = "nixos_boot";
  };
}
