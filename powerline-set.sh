#!/bin/bash
if [[ -d ~/.config/powerline ]]; then
  echo "Powerline directori exist. Removing...";
  rm -rf ~/.config/powerline;
fi
ERR=0;
echo "Creating directories for powerline configuration"
mkdir -p ~/.config/powerline;
mkdir -p  ~/.config/powerline/themes/shell;
mkdir -p  ~/.config/powerline/themes/tmux;

ERR_COUNT=$ERR+$?
if [[ $ERR_COUNT==0 ]]; then
  echo "Directory structure created"
else
  echo "Directory structure wasn't created. Some troubles";
  exit 1;
fi

ERR=0;
echo "Copying custom settings to '~/.config/powerline/config_files'"
cp -r /usr/lib/python3.6/site-packages/powerline/config_files ~/.config/powerline
cp config.json ~/.config/powerline/config.json;
cp main.json ~/.config/powerline/themes/shell/__main__.json;
cp my_leftonly.json ~/.config/powerline/themes/shell/my_leftonly.json;
cp tmux_def.json ~/.config/powerline/themes/tmux/default.json;

if [[ $ERR_COUNT==0 ]]; then
  echo "Configuration copied"
else
  echo "Configuration wasn't copied. Some troubles";
  exit 1;
fi


cat <<EOF>> ~/.bashrc

# This eanbles powerline for bash
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
fi

EOF

echo "Setting up tmux for powerline"
powerline-config tmux setup;

echo "Reloading powerline"
powerline-daemon --replace;
