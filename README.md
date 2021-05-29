# make_home

## Download and run make

Depending on how new your Mac is, you may need to install xcode tools prior to being able to use git.  Perform the following to install tools (e.g. git, make gcc).  _Note:_ Apple has updated xcode licensing so you may need to sign-in to download from: https://developer.apple.com/download/more/?name=for%20Xcode

```bash
xcode-select --install
```

Download make-home repo, which contains Makefile to set-up team repos and sync home

```bash
cd ~
git clone git@github.com:comagnaw/make-home.git
cd make-home
make
```

## Set-up GPGv2 for signed git commits

The previous section created files ~/.gnupg/gpg-agent.conf, ~/.gitconfig, ~/.gitconfig_include files and installed gnupg and pinetnry-mac.  The .gitconfig* files will need to be upated after running the following steps.

1. Create GPG key.

https://help.github.com/articles/generating-a-new-gpg-key/

2. Register GPG key with git account.

https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/

## Add GPG key to gitconfig_include

The following command will need to be run to obtain the required key for the ~/.gitconfig_include file.  The string *B295FD1* is the string required.

```bash
$ gpg --list-keys --keyid-format SHORT

/Users/llyodbraun/.gnupg/pubring.kbx
---------------------------------
pub   rsa4096/3B295FD1 2018-01-22 [SC]
      17B4BC414BEAE67641518F991EF8AAAF2E3860D8
uid         [ultimate] Llyod Braun (Serenity Now!) <lbraun@serenity.com>
sub   rsa4096/922B4DE3 2018-01-22 [E]
```

The signingkey value should be upated in ~/.gitconfig_include

```bash
$ cat .gitconfig_include

[user]
      signingkey = 3B295FD1
[commit]
        gpgsign = true
```

## Set-up Python 

Development for python should use pyenv to ensure cross version dependencies do not cause a conflict against the base python installation.  For more information referecne this [great write-up](https://alysivji.github.io/setting-up-pyenv-virtualenvwrapper.html)

```bash
# Get list of python version available.
pyenv install --list

# Install version for use in pyenv
pyenv install 2.7.15

# Activate python verison
pyenv shell [version]

# Init virutalenv on against version (only needed when first installing version)
pyenv virtualenvwrapper_lazy

# Make a virtualenv in version
mkvirtualenv [name]
```

## Set-up ZSH Shell

The zshrc references spaceship_prompt theme for formatting `$PS1`.  The default fonts do not include special fonts used in the version of spaceship and you must update the iterm2 profile to use Update iterm2 Profile to use *Hack Nerd Font Mono*.

## Set-up brew update checks and notifications

A plist file should be in the `~/Library/LaunchAgents/` which will run twice daily and notify the logged in user of any homebrew formula updates.  Check to ensure it was added into the launchd instance by the `setup-launchagent.sh`:

```bash
launchctl list | grep homebrew
-     0     homebrew.simonsimcity.update-notifier
```

You can manually add it using the following command:

```bash
launchctl load ~/Library/LaunchAgents/homebrew.simonsimcity.update-notifier.plist
```
