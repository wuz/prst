{ inputs, ... }:
{
  imports = [
    (inputs.den.namespace "personal" true)
    (inputs.den.namespace "_personal" false)
  ];
}
