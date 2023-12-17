{
  description = "A NixOS Plymouth theme displaying a fancy growing and shrinking NixOS Logo";

  outputs = inputs:
  {
    nixosModules.default = ./modules.nix;
  };
}
