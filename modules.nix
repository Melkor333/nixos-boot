{ pkgs, lib, config, ...}:
let
  # Thanks to https://github.com/bertof/nix-rice
  float = let
    inherit (builtins) fromJSON head isFloat isInt isString;
    inherit (lib.strings) splitString toInt;
    inherit (op) isNumber;
  in
  rec {
  
    # Converts the input to a float if possible (hacky but it works)
    toFloat = v:
      let
        strVal = fromJSON v;
        forceFloat = i: if isFloat i then i else i + 0.5 - 0.5;
      in
      assert (isNumber v || isString v);
      if isString v then forceFloat strVal
      else if isInt v then forceFloat v
      else v;
  
    # Round float to lower integer
    floor = f:
      let
        floatComponents = splitString "." (toString f);
        int = toInt (head floatComponents);
      in
      assert(isFloat f);
      int;
  
    # Round float to upper integer
    ceil = f:
      let
        int = div' f 1;
        inc = if mod' f 1 > 0 then 1 else 0;
      in
      assert(isFloat f);
      int + inc;
  
    # Round float to closest integer
    round = f:
      let
        int = div' f 1;
        inc = if mod' f 1 >= 0.5 then 1 else 0;
      in
      assert(isFloat f);
      int + inc;
  
    # Integer division for floats
    div' = n: d:
      assert(isNumber n);
      assert(isNumber d);
      floor (builtins.div (toFloat n) (toFloat d));
  
    # Module operator implementation for floats
    mod' = n: d:
      let
        f = div' n d;
      in
      assert(isNumber n);
      assert(isNumber d);
      n - (toFloat f) * d;
  };
  # Parse input for hex triplet
  #
  # Es: _match3hex "#001122" => ["00" "11" "22"]
  _match3hex = builtins.match "#([[:xdigit:]]{2})([[:xdigit:]]{2})([[:xdigit:]]{2})";
  hex =
  let
    inherit (builtins) getAttr hasAttr;
    inherit (lib.lists) foldl;
    inherit (lib.strings) stringToCharacters toUpper;
    inherit (lib.trivial) toHexString;
  
    # Parse a single hexadecimal digit to an integer
    _parseDigit = c:
      let
        k = toUpper c;
        dict = {
          "0" = 0;
          "1" = 1;
          "2" = 2;
          "3" = 3;
          "4" = 4;
          "5" = 5;
          "6" = 6;
          "7" = 7;
          "8" = 8;
          "9" = 9;
          "A" = 10;
          "B" = 11;
          "C" = 12;
          "D" = 13;
          "E" = 14;
          "F" = 15;
        };
      in
      assert(hasAttr k dict);
      getAttr k dict;
  
  in
  {
    # Convert an hexadecimal string to an integer
    toDec = s:
      let
        characters = stringToCharacters s;
        values = map _parseDigit characters;
      in
      foldl (acc: n: acc * 16 + n) 0 values;
  };
  hexToRgb   = s:
  let
    hext_list = _match3hex s;
    values = map (s: float.toFloat (hex.toDec s)) hex_list;
  in
  {
    red   = head values;
    green = head (tail values);
    blue  = head (drop 2 values);
  };
  toBG = { red, green, blue }:
    "${toString(255.0 / red)}, "   +
    "${toString(255.0 / green)}, " +
    "${toString(255.0 / blue)})";
in
{
  options.nixos-boot.enable = lib.mkEnableOption "nixos-boot";
  options.nixos-boot.bgColor = lib.mkOption {
    type    = lib.types.str;
    default = "#000000";
  };
  config.nixpkgs.overlays = [(self: super: {
    nixos-boot = super.callPackage ./default.nix {
      theme   = config.nixos-boot.theme;
      bgColor = toBG (hexToRgb config.nixos-boot.bgColor);
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
