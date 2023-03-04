{ config, pkgs, ... }:

let
  socketPath = "${config.home.homeDirectory}/yubikey-agent.sock";
in
{
  home.packages = [
    pkgs.yubikey-agent
  ];

  home.sessionVariables.SSH_AUTH_SOCK = socketPath;

  launchd.agents.yubikey-agent = {
    enable = pkgs.stdenv.hostPlatform.isDarwin;
    config = {
      ProgramArguments = [
        "${pkgs.yubikey-agent}/bin/yubikey-agent"
        "-l"
        socketPath
      ];
      Sockets.ssh = {
        SockPathName = socketPath;
      };
      UserName = config.home.username;
    };
  };
}
