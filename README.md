This repo contains a plymouth theme for Nixos, thanks to [discourse](https://discourse.nixos.org/t/genix7000-nix-project-logo-generator/15937/9) for giving me motivation.


Until we have a proper looking `default.nix` use it like this (and you won't have to configure anything like `plymouth.enable`, it does that automatically:

``` nix
let
  nixos-boot = pkgs.callPackage (builtins.fetchTarball "https://github.com/Melkor333/nixos-boot/archive/main.tar.gz");
in
{
  # Configure Plymouth theme
  boot.plymouth = {
    enable = true;
    themePackages = [ nixos-boot ];
    theme = "nixos-boot";
  };
  # If you want the splash screen to be visible for at least 2 seconds
  systemd.services.plymouth-quit = {
    preStart = "${pkgs.coreutils}/bin/sleep 2";
  };
}
```

The first theme, load & unload:

![nixos logo loading and unloading](./src/load_unload.gif)
