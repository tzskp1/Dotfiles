# Created by newuser for 5.0.0
# (d) is default on

# ------------------------------
# General Settings
# ------------------------------
export EDITOR=vim        # エディタをvimに設定
export LANG=ja_JP.UTF-8  # 文字コードをUTF-8に設定
export KCODE=u           # KCODEにUTF-8を設定
export AUTOFEATURE=true  # autotestでfeatureを動かす
export WAREHOUSE=192.168.0.7
export WAREHOUSE_ADDR=40:16:7e:27:bd:83
 
bindkey -v               # キーバインドをemacsモードに設定
#bindkey -v              # キーバインドをviモードに設定
bindkey '^B' vi-backward-delete-char
bindkey "^T" history-beginning-search-backward-end
bindkey "^H" history-beginning-search-forward-end
bindkey "^_" vi-cmd-mode
bindkey "^[OC" vi-forward-char
bindkey "^[OD" vi-backward-char
bindkey "^[OF" vi-end-of-line
bindkey "^[OH" vi-beginning-of-line
bindkey "^G" send-break
bindkey "^N" forward-char
bindkey "^D" backward-char

show_buffer_stack() {
  POSTDISPLAY="
stack: $LBUFFER"
  zle push-line-or-edit
}

zle -N show_buffer_stack
setopt noflowcontrol
bindkey '^Q' show_buffer_stack

zle -A .backward-kill-word vi-backward-kill-word
zle -A .backward-delete-char vi-backward-delete-char
umask 002

setopt no_beep           # ビープ音を鳴らさないようにする
setopt auto_cd           # ディレクトリ名の入力のみで移動する 
setopt auto_pushd        # cd時にディレクトリスタックにpushdする
setopt correct           # コマンドのスペルを訂正する
setopt magic_equal_subst # =以降も補完する(--prefix=/usrなど)
setopt prompt_subst      # プロンプト定義内で変数置換やコマンド置換を扱う
setopt notify            # バックグラウンドジョブの状態変化を即時報告する
setopt equals            # =commandを`which command`と同じ処理にする
setopt EXTENDED_GLOB
setopt nonomatch
setopt HIST_IGNORE_SPACE

### Complement ###
#autoload -U compinit; compinit # 補完機能を有効にする
autoload -U compinit compinit
setopt auto_list               # 補完候補を一覧で表示する(d)
setopt auto_menu               # 補完キー連打で補完候補を順に表示する(d)
setopt list_packed             # 補完候補をできるだけ詰めて表示する
setopt list_types              # 補完候補にファイルの種類も表示する
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない

### Glob ###
setopt extended_glob # グロブ機能を拡張する
unsetopt caseglob    # ファイルグロブで大文字小文字を区別しない

### History ###
HISTFILE=~/.zsh_history   # ヒストリを保存するファイル
HISTSIZE=10000            # メモリに保存されるヒストリの件数
SAVEHIST=10000            # 保存されるヒストリの件数
setopt bang_hist          # !を使ったヒストリ展開を行う(d)
setopt extended_history   # ヒストリに実行時間も保存する
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存する

# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# すべてのヒストリを表示する
function history-all { history -E 1 }

# インクリメンタルからの検索
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

# ------------------------------
# Look And Feel Settings
# ------------------------------
### Ls Color ###
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

### Prompt ###
# プロンプトに色を付ける
autoload -U colors; colors
# 一般ユーザ時
tmp_prompt="%{${fg[cyan]}%}%n%{${reset_color}%}@%{${fg[cyan]}%}%m%{${reset_color}%}# "
#tmp_prompt='%M%f %n$ '
tmp_prompt2="%{${fg[cyan]}%}%_> %{${reset_color}%}"
tmp_rprompt="%{${fg[green]}%}[%~]%{${reset_color}%}"
tmp_sprompt="%{${fg[yellow]}%}%r is correct? [Yes, No, Abort, Edit]:%{${reset_color}%}"

# rootユーザ時(太字にし、アンダーバーをつける)
if [ ${UID} -eq 0 ]; then
    tmp_prompt="%B%U${tmp_prompt}%u%b"
    tmp_prompt2="%B%U${tmp_prompt2}%u%b"
    tmp_rprompt="%B%U${tmp_rprompt}%u%b"
    tmp_sprompt="%B%U${tmp_sprompt}%u%b"
fi

PROMPT=$tmp_prompt    # 通常のプロンプト
PROMPT2=$tmp_prompt2  # セカンダリのプロンプト(コマンドが2行以上の時に表示される)
RPROMPT=$tmp_rprompt  # 右側のプロンプト
SPROMPT=$tmp_sprompt  # スペル訂正用プロンプト
# SSHログイン時のプロンプト
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
;

#Title (user@hostname) ###
#case "${TERM}" in
#   kterm*|xterm*)
        # precmd() {
        #     echo -ne "\033]0;${USER}@${HOST%%.*}\007"
        # }
#        ;;
#esac


# ------------------------------
# Other Settings
# ------------------------------

function send_emacs(){
    emacsclient $1 > /dev/null &
}

### Aliases ###
alias v=vim
alias e=send_emacs
alias ls="ls --color"
alias -g L="|less"
alias grep='grep --color=auto'

function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -d $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
  esac
}

function iso_mount(){
    local name=$(builtin cd $(dirname $0);pwd)/${1%.*}
    mkdir ${name}
    sudo mount -o loop -t iso9660 ${1} ${name}
}
    
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract
alias -s iso=iso_mount

# cdコマンド実行後、lsを実行する
function cd() {
    builtin cd $@ && ls;
}

function sands(){
    PID=$(ps x | grep -v grep | grep "xcape" | grep "space" | awk '{ print $1 }')
    if test $PID;then
        echo $PID
        ps x | grep -v grep | grep "xcape" | grep "space" | awk '{ print $1 }' | xargs kill
    fi
    xmodmap -e 'remove Lock = Caps_Lock'
    xmodmap -e 'keysym Caps_Lock = Control_L'
    xmodmap -e 'add Control = Control_L'
    xmodmap -e 'keycode 255=space'
    xmodmap -e 'keycode 65=Shift_L'
    xcape -e '#65=space'
}

# clipboard
if which pbcopy >/dev/null 2>&1 ; then 
    # Mac  
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then 
    # Linux
    alias -g C='| xsel --input --clipboard'
    alias -g P='xclip -out -sel clip'
elif which putclip >/dev/null 2>&1 ; then 
    # Cygwin 
    alias -g C='| putclip'
fi


# if [ -z $EMACS ];then
#     PID=$(ps x | grep -v grep | grep "xcape" | grep "space" | awk '{ print $1 }')
#     if [ -z $PID ];then
#         xmodmap -e 'remove Lock = Caps_Lock'
#         xmodmap -e 'keysym Caps_Lock = Control_L'
#         xmodmap -e 'add Control = Control_L'
#         xmodmap -e 'keycode 255=space'
#         xmodmap -e 'keycode 65=Shift_L'
#         xcape -e '#65=space'
#     fi
# fi


# PID=$(ps x | grep -v grep | grep "emacs" | awk '{ print $1 }')
# if [ -z $PID ];then
#     emacs &
# fi

