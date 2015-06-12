# dotfiles
I use the Ubuntu image on [DigitalOcean](http://www.digitalocean.com) for my development work,
and these dotfiles work on that image. The image comes with some default bash dotfiles already, 
so I haven't included them here. YMMV.

## installation
Clone then run `setup.sh`:

    git clone git@github.com:lessan/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ./setup.sh

The first time you run vim, [vim-plug](https://github.com/junegunn/vim-plug) will be downloaded
and plugins installed. Thereafter you can use `:PlugUpdate` to update plugins and `:PlugUpgrade`
to upgrade vim-plug itself.
