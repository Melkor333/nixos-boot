**Warning: Using this repo for some reason bloats the `initrd` quite a bit (up to 50 MB). Use it with [boot.loader.systemd-boot.configurationLimit](https://search.nixos.org/options?channel=23.05&show=boot.loader.systemd-boot.configurationLimit&from=0&size=50&sort=relevance&type=packages&query=systemd-boot) or a `/boot` of at least a gigabyte.
On EFI Systems it's also possible to keep the initrd on the main partition when switching to Grub. Checkout the [nixos wiki](https://wiki.nixos.org/wiki/Bootloader#Keeping_kernels/initrd_on_the_main_partition).**


This repo contains a plymouth theme for Nixos, thanks to [discourse](https://discourse.nixos.org/t/genix7000-nix-project-logo-generator/15937/9) for giving me motivation.

# Install

The package is currently not in nixpkgs. 

## Flakes

You can include it in your `flakes.nix` like this:

```nix
{
  inputs.nixos-boot.url = "github:Melkor333/nixos-boot";
  outputs = { self, nixpkgs, nixos-boot }:
  {
    nixosConfigurations."<hostname>" = nixpkgs.lib.nixosSystem {
      modules = [ nixos-boot.nixosModules.default ./configuration.nix ];
      system  = "x86_64-linux";
    };
  };
}

```


## Non Flakes

You can include it in your `configuration.nix` like this:

``` nix
{ config, lib, pkgs, ...}:
let
  # Fetch the repository
  nixos-boot-src = pkgs.fetchFromGitHub {
    owner = "Melkor333";
    repo = "nixos-boot";
    rev = "main";
    sha256 = "sha256-Dj8LhVTOrHEnqgONbCEKIEyglO7zQej+KS08faO9NJk=";
  };
in
{
  imports = [ "${nixos-boot-src}/modules.nix" ];
}
```

## Configuration

Enable nixos-boot in your configuration:

```nix
{ config, lib, pkgs, ...}:
{
  # ...
  nixos-boot = {
    enable  = true;

    # Different colors
    # bgColor.red   = 100; # 0 - 255
    # bgColor.green = 100; # 0 - 255
    # bgColor.blue  = 100; # 0 - 255

    # If you want to make sure the theme is seen when your computer starts too fast
    # duration = 3; # in seconds
  };
}
```

# Themes

## load_unload

The first theme, load & unload:

![nixos logo loading and unloading](./src/load_unload.gif)

## evil-nixos

The second theme, a spinning logo looking a bit communistic:

![nixos logo with communist colors](./src/evil-nixos.png)

# Adding new themes

- Create directory under src
- Copy all files as .png in there
- copy the `src/template.plymouth` to `src/THEME/THEME.plymouth`
  - replace the word THEME with the actual theme
  - adjust the description & Comment
- copy the `src/template.script` to `src/THEME/THEME.script`
  - change the line "image_quantity" to match the amount of pictures
  - Create a gif from the pngs in the folder:
  ```shell-session
  magick convert -delay 5 -loop 0 -background white $(ls -v *.png) -alpha remove THEME.gif
  ```
- Add the new entry to `modules.nix`
    ```nix
    type = lib.types.enum [ "load_unload" "evil-nixos" "THEME" ];
    ```
- Create a Readme Entry
