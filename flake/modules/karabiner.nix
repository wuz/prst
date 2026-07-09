{ ... }:
{
  nodes.karabiner = {
    home = {
      home.file.".config/karabiner/karabiner.json".text = builtins.toJSON {
        profiles = [
          {
            name = "Default profile";
            selected = true;
            simple_modifications = [
              {
                from = { key_code = "caps_lock"; };
                to = [ { key_code = "left_control"; } ];
              }
            ];
            complex_modifications = {
              rules = [
                {
                  description = "Right Command → Hyper (Ctrl+Opt+Shift)";
                  manipulators = [
                    {
                      type = "basic";
                      from = {
                        key_code = "right_command";
                        modifiers.optional = [ "any" ];
                      };
                      to = [
                        {
                          key_code = "left_shift";
                          modifiers = [
                            "left_control"
                            "left_option"
                          ];
                        }
                      ];
                    }
                  ];
                }
              ];
            };
            virtual_hid_keyboard = {
              keyboard_type_v2 = "ansi";
            };
          }
        ];
      };
    };
  };
}
