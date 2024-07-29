{ pkgs, lib, config, ... }:
let
  toBG = { red, green, blue }:
    "${toString(red   / 255.0)}, " +
    "${toString(green / 255.0)}, " +
    "${toString(blue  / 255.0)}";
  cfg = config;
  nixos-boot = pkgs.callPackage ./default.nix {
    theme = cfg.nixos-boot.theme;
    bgColor = toBG cfg.nixos-boot.bgColor;
  };
in
{
  options.nixos-boot.enable = lib.mkEnableOption "nixos-boot";
  options.nixos-boot.bgColor.red = lib.mkOption {
    type = lib.types.ints.between 0 255;
    default = 255;
  };
  options.nixos-boot.bgColor.green = lib.mkOption {
    type = lib.types.ints.between 0 255;
    default = 255;
  };
  options.nixos-boot.bgColor.blue = lib.mkOption {
    type = lib.types.ints.between 0 255;
    default = 255;
  };
  options.nixos-boot.theme = lib.mkOption {
    type = lib.types.enum [ "load_unload" "evil-nixos" ];
    default = "load_unload";
  };
  options.nixos-boot.duration = lib.mkOption {
    type = lib.types.float;
    default = 0.0;
  };
  config.boot.plymouth = lib.mkIf cfg.nixos-boot.enable {
    enable = true;
    themePackages = [ nixos-boot ];
    theme = cfg.nixos-boot.theme;
  };
  config.systemd.services.plymouth-quit = lib.mkIf (cfg.nixos-boot.enable && cfg.nixos-boot.duration > 0.0) {
    preStart = "${pkgs.coreutils}/bin/sleep ${toString config.nixos-boot.duration}";
  };
}
