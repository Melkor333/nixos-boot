This repo contains a plymouth theme for Nixos, thanks to [discourse](https://discourse.nixos.org/t/genix7000-nix-project-logo-generator/15937/9) for giving me motivation.


Until we have a proper looking `default.nix` use it like this (and you won't have to configure anything like `plymouth.enable`, it does that automatically:

``` nix
let
  nixos-boot = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [
      #...
      (import nixos-boot)
    ];
  #...
}
```

The first theme, load & unload:

![nixos logo loading and unloading](./src/load_unload.gif)
