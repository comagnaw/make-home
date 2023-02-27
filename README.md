# make_home

## Prerequisite

- [Generated ssh key and registered it with git.soma.salesforce.com.](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

## Download and run script

Download make_home repo, which contains scripts to set-up team repos and sync home

```zsh
cd ~
git clone git@git.soma.salesforce.com:msieger/make_home.git
cd make_home
scripts/install.sh all
```

## Set-up GPGv2 for signed git commits

The previous section created ~/.gitconfig_include and ~/.gitconfig_github files.  These files will need to be updated after running GPG setup.  Once the `.zshrc` has been updated via `install.sh`, `$PATH` should be updated to point to a homebrew install of gpg.

Confirm you are using homebrew install of gpg.

```zsh
$ which gpg
# Apple Silicon (arm)
/opt/homebrew/bin/gpg
# Intel Processor (i386)
/usr/local/bin/gpg
```

The following instructions will help you generate the necessary gpg keys for git.soma.salesforce.com and github.com.

1. [Create GPG key.](https://help.github.com/articles/generating-a-new-gpg-key/)
2. [Register GPG key with git account.](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account)

## Add GPG key to gitconfig_include

The following command will need to be run to obtain the required key for the ~/.gitconfig_include and ~/.gitconfig_github files.  The string *3B295FD1* is the string required.

```zsh
$ gpg --list-keys --keyid-format SHORT

/Users/llyodbraun/.gnupg/pubring.kbx
---------------------------------
pub   rsa4096/3B295FD1 2018-01-22 [SC]
      17B4BC414BEAE67641518F991EF8AAAF2E3860D8
uid         [ultimate] Llyod Braun (Serenity Now!) <lbraun@salesforce.com>
sub   rsa4096/922B4DE3 2018-01-22 [E]
```

The signingkey value should be updated in ~/.gitconfig_include

```zsh
$ cat .gitconfig_include

[user]
      signingkey = 3B295FD1
[commit]
        gpgsign = true
```

## Set-up Python

Development for python should use pyenv to ensure cross version dependencies do not cause a conflict against the base python installation.  For more information reference this [great write-up](https://alysivji.github.io/setting-up-pyenv-virtualenvwrapper.html)

```zsh
# Get list of python version available.
pyenv install --list

# Install version for use in pyenv
pyenv install 3.9.10

# Pick a default python version to use (don't use system)
pyenv global 3.9.10

# Activate python version
pyenv shell [version]

# Init virtualenv on against version (only needed when first installing new python version)
pyenv virtualenvwrapper_lazy

# Make a virtualenv in version
mkvirtualenv [name]
```

## iTerm2 Preferences

The iTerm2 preferences should be updated to point to a `${HOME}/repos/src/github.com/comagnaw/home-stuff/iterm2`.  This can be done by opening iterm, performing `<command> ,`, select General > Preferences, and selecting `Load preferences from a custom folder or URL`.  Browse to the above folder location to load the preferences.

## Set-up brew update checks and notifications

A plist file should be in the `~/Library/LaunchAgents/` which will run twice daily and notify the logged in user of any homebrew formula updates.  Check to ensure it was added into the launchd instance by the `install.sh`:

```zsh
launchctl list | grep homebrew
-     0     homebrew.simonsimcity.update-notifier
```

You can manually add it using the following command:

```zsh
launchctl load ~/Library/LaunchAgents/homebrew.simonsimcity.update-notifier.plist
```

## Install FPM

Once the `.zshrc` has been updated via `install.sh`, `$PATH` should be updated to point to a homebrew install of ruby and gem.  This should be used over the system install of ruby and gem.

Confirm you are using homebrew install of gem.

```zsh
$ which gem
# Apple Silicon (arm)
/opt/homebrew/opt/ruby/bin/gem
# Intel Processor (i386)
/usr/local/opt/ruby/bin/gem
```

Install fpm.

```zsh
gem install fpm
```
