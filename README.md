<h1 align="center">kfish610/dots</h1>

My dotfiles/configuration files for my NixOS installation, both in WSL and on
my laptop.

## Installation & Use

This is implemented as a flake, which is soft-linked as `/etc/nixos`,
then run with `sudo nixos-rebuild switch`. If the hostname of the computer does
not match exactly either `wsl` or `klaptop`, the first run must be in this
folder with `sudo nixos-rebuild switch --flake .#hostname` with whichever
hostname is desired, after which it will detect the correct configuration by
hostname as usual, since both of those configurations set the relevant hostname.

Since this is a flake, we can no longer update our installation with
`sudo nix-channel --update` or `sudo nixos-rebuild switch --upgrade`; indeed we
have little use for channels, unless you want to use `nix-shell`. Instead,
update by running `nix flake update` before rebuilding.

## Architecture & Rationale

Typically, NixOS configurations are set up with modules and submodules, which
all include their relevant parts. This is great for encapsulation and preventing
the creation of monolithic configuration files, so I am using this for both my
home-manager configuration and NixOS configuration. However, I had the
relatively specific requirement of wanting some of those modules to always be
loaded, some to be loaded only in WSL, and some to be loaded only on real
hardware. This can be done quite easily by just having different modules loaded
for those two instances, but it would require a long list of submodules in said
modules, which would make it both easy to forget a file, and fragile to filename
changes.

Since the files are relatively short for my NixOS configuration, I did implement
those with the standard module system (in `modules/`), just including the file
names in my `flake.nix`. By comparison, the `home/` directory contains a
`default.nix` file (so that I can just type `import ./home`). In this file, all
of the `.nix` files in the directory are recursively collected, then filtered to
make sure they should be enabled for the current system. This is inspired by
[infinisil's configuration](https://github.com/infinisil/system/blob/master/config/new-modules/default.nix).

## Why Flakes?

Flakes are probably one of the most confusing (albeit useful) parts of Nix at
this moment, partially due to the fact that they are "experimental" and poorly
documented, but ubiquitous. As such, I'm including a brief explanation of
flakes, in case those new to Nix have the same questions as I did.

If you want further reading, check out these articles, ordered from most to
least useful (in my opinion):

- [Zero to Nix: Flakes](https://zero-to-nix.com/concepts/flakes)
- [Nix Manual: Flake Specification](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake)
- [NixOS Wiki: Flakes](https://nixos.wiki/wiki/Flakes)
- [RFC 49, Flakes](https://github.com/NixOS/rfcs/pull/49)
- [Home Manager Manual: Using Flakes](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module)

### What problems did flakes solve?

Flakes were created primarily to fix the following issues:

- The proliferation of purpose-specific .nix files like `default.nix`,
  `shell.nix`, etc.
- Composability and dependency management were somewhat ad-hoc.
- Channels were difficult to use, especially if the package was not part of 
  `nixpkgs`.
- Expressions could be impure, hindering reproducibility.

To fix these, flakes were introduced. This was a
[somewhat controversial decision](https://discourse.nixos.org/t/why-are-flakes-still-experimental/29317/12),
particularly due to the way it was undertaken, but ultimately the community has
largely accepted flakes.

### What do flakes look like?

A flake is a directory that contains a `flake.nix` file. This `flake.nix` file
is an attribute set, with two important attributes: `inputs` and `outputs`.
`inputs` describes your dependencies, usually either packages from nixpkgs or
git repos like [home-manager](https://github.com/nix-community/home-manager),
though they can also be paths. `outputs` is a function that takes in the
realized inputs (i.e. whatever `outputs` returns in *that* flake)
and returns an attribute set. That attribute set can be more or
less anything, but there are specific attributes expected by certain commands;
`devShells` for `nix develop` (replacing `shell.nix`), `packages` for exported
packages, etc. More examples can be seen in the aforementioned articles, and an
example of a NixOS configuration is in this repo.

### How do I do X?

These are some of the points of confusion that I had the hardest time resolving
when I was first learning about flakes:

- `nix-shell` and `nix shell` do NOT do the same thing. `nix-shell` could either
  run a `shell.nix` file to start a custom shell, or it could be used with the
  `-p` option to create a shell with the given packages. It is part of the "old"
  set of nix commands. This has now been turned into two commands; `nix shell`
  and `nix develop` (notice the space).
  [`nix shell`](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-shell)
  will drop you into a shell with the given flake packages. If you want packages
  from `nixpkgs`, use `nix shell nixpkgs#hello`, or you can give it any other
  flake reference, as described in that article and the others I have linked.
  [`nix develop`](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop)
  will instead drop you into the development shell provided by `devShells` in
  the flake.
- Unless you only want to build your shell/package for a specific system, you'll
  want to use `flake-utils.lib.eachDefaultSystem`. This is because the structure
  of these attributes is `packages."<system>"."<name>"`, and you probably don't
  want to manually write a separate attribute for each system. You can also
  [write your own version of this](https://zero-to-nix.com/concepts/flakes#system-specificity) 
  pretty easily if you don't want to add another dependency.
- Flakes need to be turned on. You can do this in your NixOS config as follows:

  ```nix
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  ```
