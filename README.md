This repo contains a plymouth theme for Nixos, thanks to [discourse](https://discourse.nixos.org/t/genix7000-nix-project-logo-generator/15937/9) for giving me motivation.

The package is currently not included with nixpkgs. You can include it like this in your `configuration.nix`:

``` nix
{ config, lib, pkgs, ...}:
let
  #nixos-boot-src = import ../default.nix;
  # Fetch the repository
  nixos-boot-src = pkgs.fetchFromGitHub {
    owner = "Melkor333";
    repo = "nixos-boot";
    rev = "main";
    sha256 = "sha256-Dj8LhVTOrHEnqgONbCEKIEyglO7zQej+KS08faO9NJk=";
  };
  # define the theme you want to use
  nixos-boot = pkgs.callPackage nixos-boot-src { };

  # You might want to override the theme
  #nixos-boot = pkgs.callPackage nixos-boot-src {
  #  bgColor = "0.1, 1, 0.8"; # Weird 0-1 range RGB. In this example roughly mint
  #  theme = "load_unload";
  #};
in
{
  boot.plymouth = {
    enable = true;
    themePackages = [ nixos-boot ];
    theme = "load_unload";
  };

  # If you want to make sure the theme is seen when your computer starts too fast
  #systemd.services.plymouth-quit = {
  #  preStart = "${pkgs.coreutils}/bin/sleep 3";
  #};
}
```

The first theme, load & unload:

![nixos logo loading and unloading](./src/load_unload.gif)
