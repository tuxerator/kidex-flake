{ config, pkgs, lib, ... }:

let
  cfg = config.services.kidex;
in {
  options = {
    services.kidex = {
      enable = lib.mkEnableOption "kidex";
      package = lib.mkOption {
        defaultText = lib.literalMD "`packages.default` from the kidex flake";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.kidex = {
      Unit = {
          Description = "Kidex daemon";
          After = [ "graphical.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.writeShellScript "kidex" ''
          #!/run/current-system/sw/bin/bash
	  cat /home/jakob/.config/kidex.ron
	  ${cfg.package}/bin/kidex
	''}";
        Restart = "always";
      };

      Install = { WantedBy = [ "graphical.target" ]; };
    };

    home.packages = lib.optional (cfg.package != null) cfg.package;
  };
}


