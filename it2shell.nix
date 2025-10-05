{
  stdenvNoCC,
  fetchFromGitHub,
  runCommand,
}:
/*
This cannot be built from source as it requires entitlements and
for that it needs to be code signed. Automatic updates will have
to be disabled via preferences instead of at build time. To do
that edit $HOME/Library/Preferences/com.googlecode.iterm2.plist
and add:
SUEnableAutomaticChecks = 0;
*/
let 
  selector = ./iterm2_shell_integration_selector.sh;
in
stdenvNoCC.mkDerivation rec {
  pname = "iterm2-shell-integration";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "gnachman";
    repo = "iTerm2-shell-integration";
    rev = "2525e51";
    hash = "sha256-ffyaGZDydQAsBnwQF4HH3T7uUg2d0xJWeLS6NKsZywI=";
  };

  dontBuild = true;
  doCheck = false;
  installPhase = ''
    ls
     mkdir -p $out/bin
    mkdir -p $out/etc/profile.d
    cp ${selector} $out/etc/profile.d/iterm2_shell_integration_selector.sh
    cp utilities/* $out/bin
    cp shell_integration/zsh $out/etc/profile.d/iterm2_shell_integration.zsh
    cp shell_integration/bash $out/etc/profile.d/iterm2_shell_integration.bash
    cp shell_integration/fish $out/etc/profile.d/iterm2_shell_integration.fish
  '';
}
