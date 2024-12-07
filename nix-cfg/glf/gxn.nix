{ pkgs, ... }:

let

  gxn = pkgs.writeScriptBin "gxn" ''
    #!/usr/bin/env bash
    #!/run/current-system/sw/bin/bash

    execute_command() {
      echo -e "\033[1;33mExecuting command: sudo $1\033[0m"
      sudo $1
    }

    display_menu() {
      echo -e "\033[1;34m# ------------------------------------------------------------------------------------------------------------------ #\033[0m"
      echo -e "\033[1;31m      GXN\033[0m                                     \033[1;34mDescription\033[0m"
      echo -e "\033[1;34m# ------------------------------------------------------------------------------------------------------------------ #\033[0m"

      echo -e "\033[1;32m 1.   Rebuild\033[0m                                 Reconstruire et passer à la nouvelle configuration"
      echo -e "\033[1;32m 2.   Rollback\033[0m                                Revenir à l'avant-dernière génération"
      echo -e "\033[1;33m 3.   rebuild-all\033[0m                             Nettoyage complet (anciennes générations, paquets, cache, boot, optimiser + trim SSD)"

      echo -e ""
      echo -e "\033[1;32m 4.   nix-channel --list\033[0m                      Lister les canaux disponibles"
      echo -e "\033[1;32m 5.   Add unstable channel\033[0m                    Ajouter le canal instable"
      echo -e "\033[1;32m 6.   Delete unstable channel\033[0m                 Supprimer le canal instable"
      echo -e "\033[1;32m 7.   Refresh channels\033[0m                        Rafraîchir les canaux"

      echo -e ""
      echo -e "\033[1;34m# ------------------------------------------------------------------------------------------------------------------ #\033[0m"
      echo -e "\033[1;31m 0.   Exit\033[0m                                    Quitter le script"
      echo -e "\033[1;34m# ------------------------------------------------------------------------------------------------------------------ #\033[0m"
    }

    clear
    display_menu

    while true; do
      echo -e "\033[1;33m┌──($USER㉿$HOST)-[$(pwd)]\033[0m"
      choice=""
      echo -n -e "\033[1;33m└─\$>>\033[0m "
      read choice

      echo ""
      case $choice in
        1) execute_command "nixos-rebuild switch --upgrade" ;;
        2) execute_command "nixos-rebuild switch --rollback" ;;
        3)
          execute_command "sudo nix-store --gc"
          execute_command "sudo nix-collect-garbage -d"
          execute_command "sudo /run/current-system/bin/switch-to-configuration boot"
          execute_command "sudo fstrim -av"
          ;;

        4) execute_command "nix-channel --list" ;;
        5) execute_command "nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable" ;;
        6) execute_command "nix-channel --remove nixos-unstable" ;;
        7) execute_command "nix-channel --update" ;;

        0) exit ;;
        *) echo -e "\033[1;31mChoix invalide. Veuillez réessayer.\033[0m" ;;

      esac
      read -rsn1 -p "Appuyez sur une touche pour continuer..."
      clear
      display_menu
    done
  '';

in
{ environment.systemPackages = [ gxn ]; }
