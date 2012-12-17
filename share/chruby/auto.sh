function chruby_auto() {
	local dir="$PWD"
	local version_file

	until [[ -z "$dir" ]]; do
		version_file="$dir/.ruby-version"

		if   [[ "$version_file" == "$RUBY_VERSION_FILE" ]]; then return
		elif [[ -f "$version_file" ]]; then
			chruby $(cat "$version_file") || return 1

			export RUBY_VERSION_FILE="$version_file"
			return
		fi

		dir="${dir%/*}"
	done

	if [[ -n "$RUBY_VERSION_FILE" ]]; then
		chruby_reset
		unset RUBY_VERSION_FILE
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then precmd_functions+=("chruby_auto")
else                             PROMPT_COMMAND="chruby_auto; $PROMPT_COMMAND"
fi
