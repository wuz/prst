{
  config,
  lib,
  pkgs,
  ...
}:
let
  duckypad = pkgs.python3Packages.buildPythonApplication rec {
    pname = "duckypad";
    version = "3.4.0";

    src = pkgs.fetchzip {
      url = "https://github.com/duckyPad/duckyPad-Configurator/releases/download/${version}/duckypad_config_${version}_source.zip";
      sha256 = "sha256-dkHa41Y1coJxYRQAw/mKucAVyYNGzivzW50t2Jgd78E=";
      stripRoot = false;
    };

    format = "other";

    propagatedBuildInputs = with pkgs.python3Packages; [
      appdirs
      hidapi
      tkinter
    ];

    installPhase = ''
      # Create app bundle structure
      mkdir -p $out/Applications/duckyPad.app/Contents/{MacOS,Resources}

      # Copy all source files
      cp -r * $out/Applications/duckyPad.app/Contents/Resources/

      # Create the main executable wrapper
      cat > $out/Applications/duckyPad.app/Contents/MacOS/duckyPad <<'WRAPPER'
#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")/../Resources" && pwd)"
cd "$SCRIPT_DIR"
exec ${pkgs.python3.withPackages (ps: with ps; [ appdirs hidapi tkinter ])}/bin/python3 "$SCRIPT_DIR/duckypad_config.py" "$@"
WRAPPER
      chmod +x $out/Applications/duckyPad.app/Contents/MacOS/duckyPad

      # Create Info.plist
      cat > $out/Applications/duckyPad.app/Contents/Info.plist <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>duckyPad</string>
    <key>CFBundleIdentifier</key>
    <string>com.dekuNukem.duckypad</string>
    <key>CFBundleName</key>
    <string>duckyPad</string>
    <key>CFBundleVersion</key>
    <string>${version}</string>
    <key>CFBundleShortVersionString</key>
    <string>${version}</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

      # Copy icon if available
      if [ -f icon.icns ]; then
        cp icon.icns $out/Applications/duckyPad.app/Contents/Resources/
        # Add icon reference to Info.plist
        sed -i '/<\/dict>/i\    <key>CFBundleIconFile</key>\n    <string>icon.icns</string>' \
          $out/Applications/duckyPad.app/Contents/Info.plist
      fi

      # Create command-line wrapper
      mkdir -p $out/bin
      cat > $out/bin/duckypad <<EOF
#!/bin/sh
exec "$out/Applications/duckyPad.app/Contents/MacOS/duckyPad" "\$@"
EOF
      chmod +x $out/bin/duckypad
    '';

    meta = with lib; {
      description = "Configuration software for duckyPad";
      homepage = "https://github.com/duckyPad/duckyPad-Configurator";
      license = licenses.mit;
      maintainers = with maintainers; [ ];
      platforms = lib.platforms.darwin;
    };
  };
in
{
  environment.systemPackages = [ duckypad ];
}
