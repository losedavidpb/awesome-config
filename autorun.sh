#!/usr/bin/env bash
#
#
# @author losedavidpb

#  Function that run (only once) processes
# which spawn with the same name
function run {
   if (command -v $1 && ! pgrep $1); then
     $@&
   fi
}

## Run (only once) processes which spawn with different name
if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
    gnome-keyring-daemon --daemonize --login &
fi

if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi

if (command -v /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 && ! pgrep polkit-mate-aut) ; then
    /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
fi

if (command -v  xfce4-power-manager && ! pgrep xfce4-power-man) ; then
    xfce4-power-manager &
fi

# Run only once some nice default programs
run nm-applet
run thunar --daemon
run ~/.zshrc

## The following are not included in minimal edition by default
## but autorun.sh will pick them up if you install them
if (command -v system-config-printer-applet && ! pgrep applet.py ); then
  system-config-printer-applet &
fi

# Remove unused files
rm -rf ~/.xsession-errors.old
rm -rf ~/.xsession-errors
rm -rf ~/.lesshst
