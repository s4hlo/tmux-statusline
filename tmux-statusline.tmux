#!/usr/bin/env bash
#====================
#   Author: S4hlo
#====================

t_option() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

t_set() {
    tmux set-option -gq "$1" "$2"
}

# ------- CUSTOMIZATION --------------
STYLE=$(t_option @tmux_line_style 'angled')
JUSTIFY=$(t_option @tmux_line_justify 'left')

# ------ THEME -------
BASE=$(t_option @tmux_line_color_blue "#698DDA")
SYNC=$(t_option @tmux_line_color_red "#e06c75")
PREFIX=$(t_option @tmux_line_color_purple "#c678dd")
COPY=$(t_option @tmux_line_color_copy "#98c379")

WHITE=$(t_option @tmux_line_color_white "#abb2bf")
LIGHT_GREY=$(t_option @tmux_line_color_light_grey "#3e4452")
DARK_GREY=$(t_option @tmux_line_color_dark_grey "#282c34")
NIL=$(t_option @tmux_line_color_nil "default")

STATUS_COLOR="#{?client_prefix,$PREFIX,#{?pane_in_mode,$COPY,#{?pane_synchronized,$SYNC,$BASE}}}"

# TODO modules 
RAM="#(free -h | awk '/^Mem:/ {gsub(\"Gi\", \"GB\", \$3); gsub(\"Gi\", \"GB\", \$2); print \"RAM \" \$3 \"/\" \$2}')"
CPU="#(top -bn1 | grep \"Cpu(s)\" | awk '{printf \"CPU %04.1f%%\", \$2 + \$4}')"
GIT="#(git -C #{pane_current_path} branch --show-current  | xargs -I {} echo  {})"
DATE_FORMAT=$(t_option @tmux_power_date_format '%H:%M')
SESSION="#S"
USER="#(whoami)"
CUSTOM=$(t_option @tmux_line_indicator 'TMUX')

MODULE_A=$CUSTOM
MODULE_B=$USER
MODULE_C=$SESSION

MODULE_X=$SESSION
MODULE_Y=$RAM
MODULE_Z=$DATE_FORMAT



# ---------------------------------------
case $STYLE in
  flat)
    a_arrow="▕▏"
    i_rarrow=''
    rarrow=''
    larrow=''
    ;;
  angled)
    a_arrow="  "
    i_rarrow=''
    rarrow=''
    larrow=''
    ;;
  arrow)
    a_arrow="  "
    i_rarrow=''
    rarrow=''
    larrow=''
    ;;
  rounded)
    a_arrow="▕▏"
    i_rarrow=' '
    rarrow=''
    larrow=''
    ;;
  *)
    echo "Unknown theme: $STYLE"
    ;;
esac

# --------------------- GENERAL

# Status options
t_set status-style "fg=$WHITE,bg=$NIL"
t_set status-interval 1
t_set status-justify "$JUSTIFY"
t_set status on
t_set status-attr none

# ---------------------- LEFT SIDE OF STATUS BAR
t_set status-left-length 150

LS="#[fg=$DARK_GREY]#[bg=$STATUS_COLOR]#[bold] $MODULE_A #[fg=$STATUS_COLOR]#[bg=$LIGHT_GREY]$rarrow"
LS="$LS#[fg=$WHITE,bg=$LIGHT_GREY] $MODULE_B #[fg=$LIGHT_GREY,bg=$DARK_GREY]$rarrow $MODULE_C #[fg=$DARK_GREY,bg=$NIL]$rarrow"

t_set status-left "$LS"

# --------------------- RIGHT SIDE OF STATUS BAR
t_set status-right-length 150

RS="#[fg=$STATUS_COLOR]#[bg=$LIGHT_GREY]$larrow#[fg=$DARK_GREY]#[bg=$STATUS_COLOR]#[bold] $MODULE_Z⠀"
RS="#[fg=$LIGHT_GREY]$larrow#[fg=$WHITE]#[bg=$LIGHT_GREY]#[bold] $MODULE_Y $RS"

RS="#[fg=$DARK_GREY,bg=$NIL]$larrow#[fg=$WHITE,bg=$DARK_GREY] $MODULE_X $RS"

t_set status-right "$RS"

# ---------------------------WINDOW STATUS FORMAT
t_set window-status-format  "#[fg=$DARK_GREY,bg=default]#[bold]$i_rarrow#[fg=$WHITE,bg=$DARK_GREY] #I #W #[fg=$DARK_GREY,bg=$NIL]$rarrow"

WS="#[fg=$STATUS_COLOR]#[bg=$NIL]#[bold]$i_rarrow#[fg=$DARK_GREY]#[bg=$STATUS_COLOR]#[bold] #I #W#{?window_zoomed_flag,$a_arrow , }#[fg=$STATUS_COLOR]#[bg=$NIL]$rarrow"

t_set window-status-current-format "$WS"
# -----------------



# Window separator
t_set window-status-separator ""

# Window status style
t_set window-status-style          "fg=$STATUS_COLOR,bg=$NIL,bold"
t_set window-status-last-style     "fg=$STATUS_COLOR,bg=$NIL,none"
t_set window-status-activity-style "fg=$STATUS_COLOR,bg=$NIL,bold"

# MISCELLANEOUS SYLE
t_set pane-border-style "fg=$DARK_GREY,bg=default"
t_set pane-active-border-style "fg=$STATUS_COLOR,bg=default"
t_set display-panes-colour "$DARK_GREY"
t_set display-panes-active-colour "$STATUS_COLOR"
t_set clock-mode-colour "$STATUS_COLOR"
t_set clock-mode-style 24
t_set message-style "fg=$STATUS_COLOR,bg=$NIL"
t_set message-command-style "fg=$STATUS_COLOR,bg=$NIL"
t_set mode-style "bg=$COPY,fg=$DARK_GREY"