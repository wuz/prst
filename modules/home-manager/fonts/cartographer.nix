{ stdenv, pkgs, ... }:
let
  font_file = "";
in
stdenv.mkDerivation {
  buildInputs = with pkgs; [ nerd-font-patcher ];

}
