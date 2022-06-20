This repo contains a plymouth theme for Nixos

```
let
  nixos-boot = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
...
    boot.plymouth = {
      enable = true;
      themePackages = [ nixos-boot ];
      theme = "nixos-boot";
    };
```

![nixos logo loading and unloading](./src/load_unload.gif)
