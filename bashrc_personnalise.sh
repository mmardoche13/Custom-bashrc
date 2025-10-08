#!/bin/bash
# ===========================
#  bashrc_personnalise.sh
#  Auteur : Don-Christ Mahoungou
#  Environnement : Cybersécurité & IA
# ===========================

# --- Vérification shell interactif ---
case $- in
    *i*) ;;
      *) return;;
esac

# --- Bannière d’accueil ---
echo -e "\n\033[1;36m============================================\033[0m"
echo -e "\033[1;32m Bienvenue Don-Christ — Environnement CyberSec Ready ⚡\033[0m"
echo -e "\033[1;36m--------------------------------------------\033[0m"
echo -e " Système : $(lsb_release -d | cut -f2)"
echo -e " Utilisateur : $USER@$(hostname)"
echo -e " Date : $(date +"%A %d %B %Y — %H:%M:%S")"
echo -e "\033[1;36m============================================\033[0m\n"

# --- Historique ---
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=10000

# --- Taille du terminal ---
shopt -s checkwinsize

# --- Couleurs du prompt ---
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
fi

if [ "$color_prompt" = yes ]; then
    GREEN='\[\033[01;32m\]'
    BLUE='\[\033[01;34m\]'
    YELLOW='\[\033[01;33m\]'
    RESET='\[\033[00m\]'

    parse_git_branch() {
        git branch 2>/dev/null | grep '^*' | colrm 1 2
    }

    PS1="${YELLOW}[\t]${BLUE}[\$(parse_git_branch)] ${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}\$ "
else
    PS1='\u@\h:\w\$ '
fi

# --- Couleurs pour ls et grep ---
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# --- Alias simples ---
alias ll='ls -l --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo apt update && sudo apt upgrade -y'
alias path='echo -e ${PATH//:/\\n}'
alias ports='sudo netstat -tulanp'

# --- Alias cybersécurité ---
alias nmapscan='sudo nmap -sS -Pn'
alias pingsweep='for ip in $(seq 1 254); do ping -c1 192.168.1.$ip | grep "64 bytes" & done'
alias whoisinfo='whois'
alias getheaders='curl -I'
alias myip='curl ifconfig.me'
alias dnslookup='dig +short'

# --- Fonction pour extraire des fichiers ---
extract () {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.tar.xz)  tar xf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.rar)     unrar x "$1" ;;
      *) echo "Format non supporté : $1" ;;
    esac
  else
    echo "'$1' n'est pas un fichier valide"
  fi
}

# --- Informations système rapides ---
alias sysinfo='echo -e "\nUtilisateur : $USER\nHôte : $(hostname)\nOS : $(lsb_release -d | cut -f2)\nKernel : $(uname -r)\nIP : $(hostname -I | awk '\''{print $1}'\'')\n"'

# --- Activation de l’auto-complétion ---
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# --- Titre de la fenêtre (VirtualBox / XTerm) ---
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
