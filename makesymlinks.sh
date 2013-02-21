#!/bin/bash
######################################################################
# This script creates symlinks from the home directory to any desired
# configfiles in ~/dotfiles
######################################################################

########## Variables

dir=~/dotfiles # configfiles directory
olddir=~/.dotfiles_old # old configfiles backup directory
files="bashrc vimrc gvimrc cvsrc screenrc gitconfig hgrc dmrc zshrc"
# dircolors" # list of files/folders to symlink in homedir

##########

# create configfiles_old in homedir
echo "Creating $olddir for backup of any existing configfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the configfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing configfiles in homedir to configfiles_old directory,
# then create symlinks from the homedir to any files in the ~/dotfiles
# directory specified in $files
for file in $files; do
  echo "Moving any existing configfiles from ~ to $olddir"
  mv ~/.$file $olddir/.
  echo "Creating symlink to $file in home directory."
  ln -s $dir/$file ~/.$file
done
