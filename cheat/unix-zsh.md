---
layout: page
title: Unix - zsh
subtitle: Cheat sheet for zsh shell, mainly tested on macos 13
---

# Customising environment

- Weirdly, tab completion is off by default in macos 13. You can enable by following [these instructions](https://edwardbeazer.com/turn-auto-complete-on-for-mac-terminal/).

- To change the prompt, edit `PROMPT` in `~/.zshrc`. For example `PROMPT='%F{cyan}%n%f:~$'`. For more, see the [ZSH manual](https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion).

- In macos 13, unlike Ubuntu 22.04, ssh-rsa is deprecated; you have to turn it on if you need to connect to an old server than only uses thi. 


