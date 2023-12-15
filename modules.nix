{ pkgs, lib, config, ...}:
let
  toBG = { red, green, blue }:
    "${toString(red   / 255.0)}, "   +
    "${toString(green / 255.0)}, " +
    "${toString(blue  / 255.0)})";
in
{
  options.nixos-boot.enable = lib.mkEnableOption "nixos-boot";
  options.nixos-boot.bgColor.red = lib.mkOption {
    type    = lib.types.ints.between 0 255;
    default = 255;
  };
  options.nixos-boot.bgColor.green = lib.mkOption {
    type    = lib.types.ints.between 0 255;
    default = 255;
  };
  options.nixos-boot.bgColor.blue = lib.mkOption {
    type    = lib.types.ints.between 0 255;
    default = 255;
  };
  options.nixos-boot.theme = lib.mkOption {
    type    = lib.types.enum [ "load_unload" ];
    default = "load_unload";
  };
  options.nixos-boot.duration = lib.mkOption {
    type    = lib.types.float;
    default = 0.0;
  };
  config.nixpkgs.overlays = [(self: super: {
    nixos-boot = super.callPackage ./default.nix {
      theme   = config.nixos-boot.theme;
      bgColor = toBG config.nixos-boot.bgColor;
    };
  })];
  config.boot.plymouth = lib.mkIf config.nixos-boot.enable {
    enable = true;
    themePackages = [ pkgs.nixos-boot ];
    theme = config.nixos-boot.theme;
  };
  config.systemd.services.plymouth-quit = lib.mkIf (config.nixos-boot.enable && config.nixos-boot.duration > 0.0) {
    preStart = "${pkgs.coreutils}/bin/sleep ${toString config.nixos-boot.duration}";
  };
}
