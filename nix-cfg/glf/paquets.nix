{ pkgs, ... }:
{
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = '' flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub org.dupot.easyflatpak '';
  };

  environment.systemPackages = with pkgs;[
    # APP
    discord

    libreoffice
    hunspell
    hunspellDicts.fr-moderne
  ];
} 
