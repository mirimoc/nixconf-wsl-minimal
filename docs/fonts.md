# Fonts on WSL

## The gotcha

Windows Terminal (and every other Windows app) renders text using **Windows-installed fonts**. Fonts installed inside WSL via Nix are only visible to Linux GUI apps running under WSL — Windows Terminal does not see them.

So to use a Nerd Font like Monofur in Windows Terminal, you need it installed **on Windows**, not inside WSL. Installing via Nix gets you the font files — you then copy them to Windows once.

## One-time setup

After a switch that includes the font package:

```bash
# Find the font files Nix put into your profile
find ~/.nix-profile/share/fonts -name '*.ttf' -o -name '*.otf' 2>/dev/null
```

Copy them to your Windows user's Downloads folder (or anywhere accessible from Explorer):

```bash
# Replace 'YourWindowsUser' with your actual Windows username
cp ~/.nix-profile/share/fonts/truetype/NerdFonts/Monofur/*.ttf \
   /mnt/c/Users/YourWindowsUser/Downloads/
```

In Windows:

1. Open `C:\Users\YourWindowsUser\Downloads` in Explorer
2. Select the `.ttf` files, right-click → **Install for all users** (or **Install** for current user)
3. Restart Windows Terminal
4. Settings → your profile → **Font face** → pick `Monofur Nerd Font`

## Adding more Nerd Fonts

In `home/packages.nix`:

```nix
home.packages = with pkgs; [
  nerd-fonts.monofur
  nerd-fonts.fira-code
  nerd-fonts.jetbrains-mono
  # ...
];
```

Full list: https://search.nixos.org/packages?query=nerd-fonts

After `sw`, copy the new files to Windows with the same procedure.

## Why install at all via Nix?

- Linux GUI apps under WSL (rare, but possible) see them automatically.
- Acts as a single source of truth — the font is in your declarative config.
- Easier to keep track of which fonts a machine "should have".

If you only ever use Windows Terminal on this machine and never plan to use Linux GUI apps, you can skip the Nix font install and just download the font from [nerdfonts.com](https://www.nerdfonts.com/) directly to Windows.
