# make_home

## Download and run make

Download make-home repo, which contains Makefile to set-up team repos and sync home

```
cd ~
git clone git@github.com:comagnaw/make-home.git
cd make-home
make prep
make get
make finish
```

## Set-up GPGv2 for signed git commits

The previous section created ~/.gitconfig and ~/.gitconfig_include files.  These files will need to be upated after running GPG setup.  The following steps require brew to be installed.

1. Install GPGv2 and pinentry-mac
```
#
# This will most likely install gnupg v2 (This is recommended version).
#
brew install gnupg 

#
# This is required to interact with MacOSX keychain.
#
brew install pinentry-mac

#
# Set-up gpg-agent to point to pinentry-mac
#
mkdir ~/.gnupg
echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
```

2. Create GPG key.

https://help.github.com/articles/generating-a-new-gpg-key/

3. Register GPG key with git account.

https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/

## Add GPG key to gitconfig_include

The following command will need to be run to obtain the required key for the ~/.gitconfig_include file.  The string *B295FD1* is the string required.

```
$gpg --list-keys --keyid-format SHORT

/Users/llyodbraun/.gnupg/pubring.kbx
---------------------------------
pub   rsa4096/3B295FD1 2018-01-22 [SC]
      17B4BC414BEAE67641518F991EF8AAAF2E3860D8
uid         [ultimate] Llyod Braun (Serenity Now!) <lbraun@serenity.com>
sub   rsa4096/922B4DE3 2018-01-22 [E]
```

The signingkey value should be upated in ~/.gitconfig_include

```
$ cat .gitconfig_include

[user]
	signingkey = 3B295FD1
[commit]
        gpgsign = true
```

## Set-up Python

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install python

ln -s /usr/local/bin/python2 /usr/local/bin/python
ln -s /usr/local/bin/pip2 /usr/local/bin/pip

pip install --upgrade pip setuptools

pip install virtualenv

mkdir ~/.pyenvs
mkdir ~/repos/pyprojects

pip install virtualenvwrapper

pip install ptpython
```

## Set-up Powerline Shell
The bashrc references powerline-shell for formatting `$PS1`.  The below steps need to be done to install powerline-shell and the supported fonts.

```
pip install powerline-shell
```

```
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
```

Update iterm2 Profile to use *12pt Roboto Mono for Powerline*

## Set-up brew update checks and notifications

```
brew install terminal-notifier
```
