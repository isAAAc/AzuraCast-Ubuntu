# AzuraCast Traditional Installer for Ubuntu 22.04 LTS

**Some things to know:**

- This installer only supports Ubuntu 22.04.
- It installs AzuraCast in its stable version without Docker (currently version 0.17.6).
- It can be used for both installation and update processes (though updates are not yet implemented).

If you need help with this great product, check out AzuraCast here: <https://github.com/AzuraCast/AzuraCast>.

Before asking a question, you may want to take a look at AzuraCast's great documentation here: <https://docs.azuracast.com/>.

If you want to help the developers of AzuraCast, take a look here: <https://docs.azuracast.com/en/contribute/donate>.

## Why I used my own repository for this

Personally, I plan to use AzuraCast in a modified way (I only need the AutoDJ feature). I need a fast way to react to changes and make modifications, and the most important reason is security. I know what I have done here. If I use the repository on other sites, I will have to check what has been changed. I dislike unplanned work, so please understand that I can only ensure this in this way. However, it is easy to add this to the default repository. Personally, I don't feel that this is something that the developers want outside of their Docker business.

## How to install

Just one line for you.

```
mkdir /root/azuracast_installer && cd /root/azuracast_installer && git clone https://github.com/scysys/AzuraCast-Ubuntu.git . && chmod +x install.sh && ./install.sh -i
```

After installation, make sure that everything is working. If you encounter any issues related to the installer, please report them directly here and do not disturb the AzuraCast developers with errors that are related to this repository.

![#f03c15](https://placehold.co/15x15/f03c15/f03c15.png) *You must reboot after your first install!*

## Available Commands
Usage: install.sh --help or install.sh -h

*Installation / Upgrade*
- `-i`, `--install`: Install the latest stable version of AzuraCast.
- `-v`, `--version`: Display version information.
- `-h`, `--help`: Display this help text.

## Tested with
- OVH
- Hetzner
- Digitalocean

I'll run automatic tests with these 3 Hosters on every version. Ubuntu 22.04 LTS does not mean that some hosters outside are doing their own business with their images. Whatever. If you encounter an error, just open an issue with some logs.
  
## Future
- Add upgrade process
- Add options to update Icecast KH itself
- Change panel ports over installer
- We need more?
  - the backup integration ?
