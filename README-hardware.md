# Configuration Hardware

Le fichier `hardware-configuration.nix` n'est **pas** dans git car il est spécifique à chaque machine.

## Sur chaque PC

Avant le premier `nixos-rebuild`, générez le hardware-configuration.nix local :

```bash
sudo nixos-generate-config --show-hardware-config > /etc/nixos/hardware-configuration.nix
```

La configuration dans `hosts/nixos/default.nix` l'importera depuis `/etc/nixos/hardware-configuration.nix`.
