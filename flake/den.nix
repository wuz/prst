{ den, inputs, ... }: {
  imports = [ inputs.den.flakeModules.default ];

  den.default.includes = [ den._.define-user ];
}
