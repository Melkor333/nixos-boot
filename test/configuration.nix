{ config, lib, pkgs, ...}:

let
  nixos_boot = pkgs.callPackage ../default.nix {
  #bgColor = "0, 0, 0"; # Test black background color
  # theme = "load_unload";
  };
in
{
  networking.hostName = "testvm"; # Define your hostname.
  boot.loader.systemd-boot.enable = true;
  boot.initrd.systemd.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth = {
    enable = true;
    themePackages = [ nixos_boot ];
    theme = "nixos_boot";
  };
  systemd.services.plymouth-quit = {
    preStart = "${pkgs.coreutils}/bin/sleep 5";
  };
  # Test user to log in
  users.users.test = {
    isSystemUser = true;
    initialPassword = "test";
  };
  users.users.test.group = "test";
  users.groups.test = {};
  system.stateVersion = "23.05"; # Did you read the comment?
}
