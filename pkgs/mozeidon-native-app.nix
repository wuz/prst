{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mozeidon-native-app";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "egovelox";
    repo = "mozeidon-native-app";
    rev = "v${version}";
    hash = "sha256-NulweIdP9vC3pWNjgC5DaYVOpY7Sx+VJ3tO7geYCeZ0=";
  };

  vendorHash = "sha256-dcvTffcQQMzNempfuX/SmqBsdPLVX4nVhGfV5RNtSHU=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  postInstall = ''
    mkdir -p $out/lib/mozilla/native-messaging-hosts
    cat > $out/lib/mozilla/native-messaging-hosts/mozeidon.json <<EOF
    {
      "name": "mozeidon",
      "description": "Native messaging add-on to interact with your browser",
      "path": "$out/bin/mozeidon-native-app",
      "type": "stdio",
      "allowed_extensions": [
        "mozeidon-addon@egovelox.com"
      ]
    }
    EOF
  '';

  meta = {
    homepage = "https://github.com/egovelox/mozeidon-native-app";
    description = "Native app for the Mozeidon Firefox addon";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mozeidon-native-app";
  };
}
