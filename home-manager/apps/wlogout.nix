{ pkgs, lib, ... }:
let
  bgImageSection = name: ''
    #${name} {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/${name}.png"));
    }
  '';
in
{
  programs.wlogout = {
    enable = true;

    style = ''
      * {
        background: none;
      }

      window {
        background-color: rgba(0, 0, 0, .7);
      }

      button {
        background: rgba(0, 0, 0, .05);
        border-radius: 8px;
        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .1), 0 0 rgba(0, 0, 0, .5);
        margin: 1rem;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }

      button:focus, button:active, button:hover {
        background-color: rgba(205, 205, 255, 0.2);
        background-size: 20%;
        outline-style: none;
      }

      ${lib.concatMapStringsSep "\n" bgImageSection [
        "logout"
        "shutdown"
        "reboot"
      ]}
    '';
    layout = [
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "󰜉 Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "󰐥 Shutdown";
        keybind = "s";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit 0";
        text = "󰍃 Logout";
        keybind = "e";
      }
    ];
  };
}
