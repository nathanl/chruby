unset RUBY_AUTO_VERSION

function chruby_auto() {
  echo 'auto-picking a ruby'
  # if [ -z "$PS1" ]; then
  #   echo 'This shell is not interactive'
  # else
  #   echo 'This shell is interactive'
  # fi

	local dir="$PWD/" version

	until [[ -z "$dir" ]]; do
		dir="${dir%/*}"

		if { read -r version <"$dir/.ruby-version"; } 2>/dev/null || [[ -n "$version" ]]; then
			if [[ "$version" == "$RUBY_AUTO_VERSION" ]]; then return
			else
				RUBY_AUTO_VERSION="$version"
				chruby "$version"
				return $?
			fi
		fi
	done

	if [[ -n "$RUBY_AUTO_VERSION" ]]; then
		chruby_reset
		unset RUBY_AUTO_VERSION
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then
	if [[ ! "$chpwd_functions" == *chruby_auto* ]]; then
		chpwd_functions+=("chruby_auto")
	fi
elif [[ -n "$BASH_VERSION" ]]; then
	trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chruby_auto' DEBUG
fi

# Execute once at start of shell.
chruby_auto

# See if there's some way to run this AFTER every command in bash
# http://unix.stackexchange.com/questions/171764/how-can-i-run-a-command-in-bash-after-any-change-in-pwd
function check_pwd() {
  if [ "$CHRUBY_PREVIOUS_PWD" != "$PWD" ]; then
    chruby_auto
  fi
  CHRUBY_PREVIOUS_PWD=$PWD
}
