# Custom aliases
alias aurup='yaourt -Syua'
alias pacupa='yaourt -Syu --aur'
alias pacup='sudo pacman -Syu'
alias vmplayer='primusrun vmplayer'
alias vmware='primusrun vmware'
alias wacompr='wacom-profile-switcher.sh'
alias gits='git status'
alias gita='git add'
alias gitch='git checkout'
alias gitbr='git branch'
alias gitch-b='git checkout -b'
alias gitbr-d='git branch -d'
alias gitme='git merge'
alias gitcm='git commit -m'
alias gitr='git remote'
alias hist='log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
alias rmgl="rm -rf .git/index.lock"
alias dev-sc="rm -rf .git && git init && pnpm i"
alias ll="ls -lhA"
alias pfind="ps aux | grep"
alias apache-droot="grep -R "DocumentRoot" /etc/apache2/sites-enabled"
alias mkfat32="sudo mkdosfs -F 32 -I"
alias rmf='rm -rf'
alias ls1='ls -1'
alias lsa='ls -1a'
alias errors="journalctl -b -p err|less"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias myip="curl http://ipecho.net/plain; echo"
alias busy.port="netstat -tanpl|grep"
alias jr.err="journalctl -p err..alert"
alias fix.icons="sudo sed -i 's/Context=Mimetypes/Context=MimeTypes/g; s/Context=Apps/Context=Applications/g ' /usr/share/icons/*/index.theme"
alias  genpass="cat /dev/urandom | tr -dc a-zA-Z0-9 | fold -w 32 | head -n 1"
alias gfix="gita . && gitcm 'some fixes' && git push"
alias manjaro-pool-pkg="https://mirror.netzspielplatz.de/manjaro/packages/pool/overlay/"
