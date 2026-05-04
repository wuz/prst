{
  lib,
  pkgs,
  ...
}:
let
  duckypad = pkgs.python3Packages.buildPythonApplication rec {
    pname = "duckypad";
    version = "4.0.2";

    src = pkgs.fetchzip {
      url = "https://github.com/duckyPad/duckyPad-Configurator/releases/download/${version}/duckypad_config_${version}_source.zip";
      sha256 = "sha256-H0NJD1RVu48bGVCtqRKFZUunMx4RXW0pXSAsxajyJ3w=";
      stripRoot = false;
    };

    format = "other";

    propagatedBuildInputs = with pkgs.python3Packages; [
      certifi
      darkdetect
      hidapi
      platformdirs
      psutil
      requests
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
      exec ${
        pkgs.python3.withPackages (
          ps: with ps; [
            certifi
            darkdetect
            hidapi
            platformdirs
            psutil
            requests
            tkinter
          ]
        )
      }/bin/python3 "$SCRIPT_DIR/duckypad_config.py" "$@"
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

    meta = {
      description = "Configuration software for duckyPad";
      homepage = "https://github.com/duckyPad/duckyPad-Configurator";
      license = lib.licenses.mit;
      maintainers = [ ];
      platforms = lib.platforms.darwin;
    };
  };
  duckypad-autoswitcher = pkgs.python3Packages.buildPythonApplication rec {
    pname = "duckypad-autoswitcher";
    version = "1.2.1";

    src = pkgs.fetchFromGitHub {
      owner = "duckyPad";
      repo = "duckyPad-Profile-Autoswitcher";
      rev = version;
      sha256 = "sha256-dITNFXUMIYRhJG5ORpbpDirWTDctnqwdnG3T55rms2I=";
    };

    format = "other";

    propagatedBuildInputs = with pkgs.python3Packages; [
      certifi
      hidapi
      platformdirs
      pyobjc-framework-Cocoa
      pyobjc-framework-Quartz
      tkinter
    ];

    installPhase = ''
            mkdir -p $out/Applications/duckyPadAutoswitcher.app/Contents/{MacOS,Resources}

            cp -r src/* $out/Applications/duckyPadAutoswitcher.app/Contents/Resources/

            cat > $out/Applications/duckyPadAutoswitcher.app/Contents/MacOS/duckyPadAutoswitcher <<'WRAPPER'
      #!/bin/sh
      SCRIPT_DIR="$(cd "$(dirname "$0")/../Resources" && pwd)"
      cd "$SCRIPT_DIR"
      exec ${
        pkgs.python3.withPackages (
          ps: with ps; [
            certifi
            hidapi
            platformdirs
            pyobjc-framework-Cocoa
            pyobjc-framework-Quartz
            tkinter
          ]
        )
      }/bin/python3 "$SCRIPT_DIR/duckypad_autoprofile.py" "$@"
      WRAPPER
            chmod +x $out/Applications/duckyPadAutoswitcher.app/Contents/MacOS/duckyPadAutoswitcher

            cat > $out/Applications/duckyPadAutoswitcher.app/Contents/Info.plist <<'PLIST'
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>CFBundleExecutable</key>
          <string>duckyPadAutoswitcher</string>
          <key>CFBundleIdentifier</key>
          <string>com.dekuNukem.duckypad-autoswitcher</string>
          <key>CFBundleName</key>
          <string>duckyPad Autoswitcher</string>
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

            mkdir -p $out/bin
            cat > $out/bin/duckypad-autoswitcher <<EOF
      #!/bin/sh
      exec "$out/Applications/duckyPadAutoswitcher.app/Contents/MacOS/duckyPadAutoswitcher" "\$@"
      EOF
            chmod +x $out/bin/duckypad-autoswitcher
    '';

    meta = {
      description = "Auto-switches duckyPad profiles based on the active window";
      homepage = "https://github.com/duckyPad/duckyPad-Profile-Autoswitcher";
      license = lib.licenses.mit;
      maintainers = [ ];
      platforms = lib.platforms.darwin;
    };
  };
in
{
  environment.systemPackages = [
    duckypad
    duckypad-autoswitcher
  ];

  # macOS TCC permissions cannot be granted programmatically (SIP prevents it).
  # This script opens the relevant System Settings panes so the user only needs
  # to flip the toggles for Terminal (or whichever app launches duckypad).
  system.activationScripts.duckypadPermissions.text = ''
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              duckyPad — Permissions Required                 ║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║  duckyPad needs two macOS permissions to function:           ║"
    echo "║                                                              ║"
    echo "║  1. Input Monitoring  (to read HID/keyboard events)          ║"
    echo "║  2. Full Disk Access  (to read/write config files)           ║"
    echo "║                                                              ║"
    echo "║  Grant both to Terminal (or your terminal emulator).         ║"
    echo "║  System Settings panes will open automatically.              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    # Open Input Monitoring pane
    open "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent" || true
    # Open Full Disk Access pane
    open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles" || true
  '';
}
