{ inputs, ... }:
{
  imports = [
    (inputs.den.namespace "work" true)
    (inputs.den.namespace "_work" false)
  ];
}
