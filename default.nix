{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.iterm2-shell-integration;
  enabledOption =
    x:
    lib.mkEnableOption x
    // {
      default = true;
      example = false;
    };
    iterm2-shell-integration-pkg = builtins.fetchGit "https://github.com/skyethepinkcat/nix-iterm2-shell-integration";
in
{
  options.programs.iterm2-shell-integration = {

    enable = lib.mkEnableOption ''
      direnv integration. Takes care of both installation and
      setting up the sourcing of the shell. Additionally enables nix-direnv
      integration. Note that you need to logout and login for this change to apply
    '';

    package = lib.mkPackageOption iterm2-shell-integration-pkg "iterm2-shell-integration" { };

    enableBashIntegration = enabledOption ''
      Bash integration
    '';
    enableZshIntegration = enabledOption ''
      Zsh integration
    '';
    enableFishIntegration = enabledOption ''
      Fish integration
    '';

    loadInNixShell = enabledOption ''
      loading direnv in `nix-shell` `nix shell` or `nix develop`
    '';

  };

  config = lib.mkIf cfg.enable {
    programs = {
      zsh.interactiveShellInit = lib.mkIf cfg.enableZshIntegration ''
        if ${lib.boolToString cfg.loadInNixShell} || printenv PATH | grep -vqc '/nix/store'; then
          source ${cfg.package}/share/iterm2-shell-integration/iterm2_shell_integration.zsh
        fi
      '';

      #$NIX_GCROOT for "nix develop" https://github.com/NixOS/nix/blob/6db66ebfc55769edd0c6bc70fcbd76246d4d26e0/src/nix/develop.cc#L530
      #$IN_NIX_SHELL for "nix-shell"
      bash.interactiveShellInit = lib.mkIf cfg.enableBashIntegration ''
        if ${lib.boolToString cfg.loadInNixShell} || [ -z "$IN_NIX_SHELL$NIX_GCROOT$(printenv PATH | grep '/nix/store')" ] ; then
          source ${cfg.package}/share/iterm2-shell-integration/iterm2_shell_integration.bash
        fi
      '';

      fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration ''
        if ${lib.boolToString cfg.loadInNixShell}; or printenv PATH | grep -vqc '/nix/store';
          source ${cfg.package}/share/iterm2-shell-integration/iterm2_shell_integration.fish
        end
      '';

    };

    environment = {
      systemPackages = [
        cfg.package
      ];
    };
  };
}
