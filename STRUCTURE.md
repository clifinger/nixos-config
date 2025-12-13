# NixOS Config Structure

## 📁 Organization

```
nixos-config/
├── flake.nix                    # Entry point - orchestrates everything
├── flake.lock                   # Locked versions of dependencies
├── hardware-configuration.nix   # Auto-generated hardware config
│
├── hosts/nixos/                 # System configuration (USED BY FLAKE)
│   └── default.nix             # Main system config, imports from system/
│
├── system/                      # System modules (split for clarity)
│   ├── boot.nix
│   ├── networking.nix
│   ├── audio.nix
│   └── ...
│
├── users/julien/                # User home-manager config
│   └── default.nix             # Imports from home/ modules
│
├── home/                        # Home-manager modules (reusable)
│   ├── programs/               # Program configs (zsh, kitty, nvim, etc)
│   ├── wm/                     # Window manager configs
│   └── services/
│
├── desktop/                     # Desktop environment configs
└── scripts/                     # Helper scripts
```

## 🔄 How it works

1. `flake.nix` loads `hosts/nixos/default.nix` for system config
2. System config imports modules from `system/`
3. Home-manager loads `users/julien/default.nix` for user config
4. User config imports modules from `home/programs/` and `home/wm/`

## 🚀 Quick commands

- Rebuild: `sudo nixos-rebuild switch --flake .#nixos`
- Update: `nix flake update`
- Check: `nix flake check`
