#!/bin/sh
# GruvboxDark

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
put_template 0  "28/28/28"
put_template 1  "cc/24/1d"
put_template 2  "98/97/1a"
put_template 3  "d7/99/21"
put_template 4  "45/85/88"
put_template 5  "b1/62/86"
put_template 6  "68/9d/6a"
put_template 7  "a8/99/84"
put_template 8  "92/83/74"
put_template 9  "fb/49/34"
put_template 10 "b8/bb/26"
put_template 11 "fa/bd/2f"
put_template 12 "83/a5/98"
put_template 13 "d3/86/9b"
put_template 14 "8e/c0/7c"
put_template 15 "eb/db/b2"

color_foreground="eb/db/b2"
color_background="28/28/28"

if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg "ebdbb2"
  put_template_custom Ph "282828"
  put_template_custom Pi "ebdbb2"
  put_template_custom Pj "665c54"
  put_template_custom Pk "ebdbb2"
  put_template_custom Pl "ebdbb2"
  put_template_custom Pm "282828"
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
