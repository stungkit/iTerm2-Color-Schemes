#!/bin/sh
# Guezwhoz

# source for these helper functions:
# https://github.com/chriskempson/base16-shell/blob/master/templates/default.mustache
if [ -n "$TMUX" ]; then
  # Tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $@; }
elif [ "${TERM%%[-.]*}" = "screen" ]; then
  # GNU screen (screen, screen-256color, screen-256color-bce)
  put_template() { printf '\033P\033]4;%d;rgb:%s\007\033\\' $@; }
  put_template_var() { printf '\033P\033]%d;rgb:%s\007\033\\' $@; }
  put_template_custom() { printf '\033P\033]%s%s\007\033\\' $@; }
elif [ "${TERM%%-*}" = "linux" ]; then
  put_template() { [ $1 -lt 16 ] && printf "\e]P%x%s" $1 $(echo $2 | sed 's/\///g'); }
  put_template_var() { true; }
  put_template_custom() { true; }
else
  put_template() { printf '\033]4;%d;rgb:%s\033\\' $@; }
  put_template_var() { printf '\033]%d;rgb:%s\033\\' $@; }
  put_template_custom() { printf '\033]%s%s\033\\' $@; }
fi

# 16 color space
put_template 0  "08/08/08"
put_template 1  "ff/5f/5f"
put_template 2  "87/d7/af"
put_template 3  "d7/d7/87"
put_template 4  "5f/af/d7"
put_template 5  "af/af/ff"
put_template 6  "5f/d7/d7"
put_template 7  "da/da/da"
put_template 8  "8a/8a/8a"
put_template 9  "d7/5f/5f"
put_template 10 "af/d7/af"
put_template 11 "d7/d7/af"
put_template 12 "87/af/d7"
put_template 13 "af/af/d7"
put_template 14 "87/d7/d7"
put_template 15 "da/da/da"

color_foreground="d0/d0/d0"
color_background="1c/1c/1c"

if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg "d0d0d0"
  put_template_custom Ph "1c1c1c"
  put_template_custom Pi "eeeeee"
  put_template_custom Pj "005f5f"
  put_template_custom Pk "eeeeee"
  put_template_custom Pl "eeeeee"
  put_template_custom Pm "eeeeee"
else
  put_template_var 10 $color_foreground
  put_template_var 11 $color_background
  if [ "${TERM%%-*}" = "rxvt" ]; then
    put_template_var 708 $color_background # internal border (rxvt)
  fi
  put_template_custom 12 ";7" # cursor (reverse video)
fi

# clean up
unset -f put_template
unset -f put_template_var
unset -f put_template_custom

unset color_foreground
unset color_background
