
Zal's dotfiles and other oddities
=================================

This is a repository of my linux dotfiles for bash, vim etc., which I put here
mainly for later reference and so I can syncronize them across computers.

Note that most of these aren't the dotfiles per-se, but are instead sourced from
the respective dotfiles. This prevents the hassle of dealing with symlinks, as 
well as allowing for machine specific config.

bash
----
The bash/ folder currently contains aliases and scripts that implement a basic
powerline inspired prompt in pure bash. Powerline fonts are assumed, but could 
be easily replaced.

The prompt is not as sophisticated as powerline. Writing this was more about
doing what zsh people have with the tools I had at hand.

To use the prompt, source prompt.bash and add 
`PROMPT_COMMAND="__prompt_update"` to your `.bashrc`. 

Also, you probably don't have to worry about this, but an ANSI compatible
terminal is required. If you *do* care about this, you probably own a very
cool terminal and I want to hear all about it. Maybe grab a coffee sometime?

vim
---
The file `vim/zal.vim` contains my vim config. Nothing fancy, just a list of
globals that configure vim the way I like it.

My vim config assumes the following plugins are installed:
    - airline
    - ctrlp
    - the-silver-searcher
    - nerdtree

