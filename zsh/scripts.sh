# User configuration

if [ $(command -v "nvim") ]; then
  if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
  else
    export EDITOR='nvim'
  fi
fi

if [ -z "${DISABLE_DIRENV}" ]; then
	_direnv_hook() {
	  trap -- '' SIGINT;
	  eval "$("/usr/local/bin/direnv" export zsh)";
	  trap - SIGINT;
	}
	typeset -ag precmd_functions;
	if [[ -z ${precmd_functions[(r)_direnv_hook]} ]]; then
	  precmd_functions=( _direnv_hook ${precmd_functions[@]} )
	fi
	typeset -ag chpwd_functions;
	if [[ -z ${chpwd_functions[(r)_direnv_hook]} ]]; then
	  chpwd_functions=( _direnv_hook ${chpwd_functions[@]} )
	fi
fi

if [ $(command -v "networksetup") ]; then
  # Toggle HTTP/HTTPS proxy from cmd line
  # pxy_on "Wi-Fi"
  # pxy_on "Thunderbolt Ethernet"
  function pxy_on() {
    networksetup -setwebproxystate $1 on
    networksetup -setsecurewebproxystate $1 on
  }

  # Toggle HTTP/HTTPS proxy from cmd line
  # pxy_off "Wi-Fi"
  # pxy_off "Thunderbolt Ethernet"
  function pxy_off() {
    networksetup -setwebproxystate $1 off
    networksetup -setsecurewebproxystate $1 off
  }
fi

matrix () {
  local lines=$(tput lines)
  cols=$(tput cols)

  awkscript='
  {
        letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
        lines=$1
        random_col=$3
        c=$4
        letter=substr(letters,c,1)
        cols[random_col]=0;
        for (col in cols) {
            line=cols[col];
            cols[col]=cols[col]+1;
            printf "\033[%s;%sH\033[2;32m%s", line, col, letter;
            printf "\033[%s;%sH\033[1;37m%s\033[0;0H", cols[col], col, letter;
            if (cols[col] >= lines) {
                cols[col]=0;
            }
    }
}
'

  echo -e "\e[1;40m"
  clear

  while :; do
      echo $lines $cols $(( $RANDOM % $cols)) $(( $RANDOM % 72 ))
      sleep 0.05
  done | awk "$awkscript"
}

