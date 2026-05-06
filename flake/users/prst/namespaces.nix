{ inputs, ... }:
{
  imports = [
    (inputs.den.namespace "prst" true)
    (inputs.den.namespace "_prst" false)
  ];
}
