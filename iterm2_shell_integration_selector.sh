#!/usr/bin/env bash

if $SHELL == "zsh"; then
    source iterm2_shell_integration.zsh
elif $SHELL == "bash"; then
    source iterm2_shell_integration.bash
elif $SHELL == "fish"; then
    source iterm2_shell_integration.fish
fi
