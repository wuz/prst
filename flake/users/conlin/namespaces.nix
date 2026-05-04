{ inputs, ... }:
{
  imports = [
    (inputs.den.namespace "conlin" true)
    (inputs.den.namespace "_conlin" false)
  ];
}
