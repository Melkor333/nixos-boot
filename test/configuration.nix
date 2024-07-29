{ pkgs, ... }:

let
  nixos-boot-src = import ../default.nix;
  theme = "evil-nixos";
  delay = "4";
  # Fetch the repository
  #nixos-boot-src = pkgs.fetchFromGitHub {
  #  owner = "Melkor333";
  #  repo = "nixos-boot";
  #  rev = "add-tests";
  #  sha256 = "sha256-Tk8716LK8LNSM3uvDsVlps37KVqCvqR6riMmjdTBTAE=";
  #};
  # define the package
  nixos-boot = pkgs.callPackage nixos-boot-src {
    bgColor = "0.1, 1, 0.8"; # Test roughly mint background color
    theme = theme;
  };
in
{
  networking.hostName = "testvm"; # Define your hostname.
  boot.loader.systemd-boot.enable = true;
  boot.initrd.systemd.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelParams = [ "plymouth.debug" ];
  boot.plymouth = {
    enable = true;
    themePackages = [ nixos-boot ];
    theme = theme;
    extraConfig = ''
      [Daemon]
      ShowDelay=${delay}
    '';
  };
  systemd.services.plymouth-quit = {
    preStart = "${pkgs.coreutils}/bin/sleep ${delay}";
  };
  # Test user to log in
  users.users.test = {
    isSystemUser = true;
    initialPassword = "test";
  };
  users.users.test.group = "test";
  users.groups.test = { };
  system.stateVersion = "23.05"; # Did you read the comment?
}
