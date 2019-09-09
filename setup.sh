#!/bin/bash

if [ ! -d $HOME/.oh-my-zsh ]; then
  echo "installing: oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  echo "found: oh-my-zsh"
fi

files=(
  "./git/.gitconfig"
  "./vim/.vimrc"
  "./vim/.vimrc.after"
  "./vim/.vimrc.before"
  "./vim/.vimrc.bundles"
  "./zsh/.zshrc"
)
for file in "${files[@]}"
do
  filename=$(basename $file)
  if [ -h "$HOME/$filename" ]; then
    echo "found: $filename"
  else
    echo "adding: $file"
    ln -s $file $HOME/
  fi
done

echo "overwriting tmux conf"
rm $HOME/.tmux.conf
ln -s ./tmux/.tmux.conf $HOME/.tmux.conf
