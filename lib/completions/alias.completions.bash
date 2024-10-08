# shellcheck shell=bash
####################################################################
# alias.completions.bash
####################################################################
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2020-2021 Bash-it
####################################################################
# Load after all aliases and completions to understand what needs to be completed
#
# References:
# http://superuser.com/a/437508/119764
# http://stackoverflow.com/a/1793178/1228454
# https://github.com/Bash-it/bash-it
####################################################################
# METADATA
####################################################################
about 'Automatic completion for aliases'
group 'completions'
####################################################################
# FUNCTIONS
####################################################################
completion::callback::alias()
{
    local namespace='completion_aliases'
    local completions tmp_file completion_loader line new_completion compl_func compl_wrapper
    local alias_name alias_defn alias_cmd alias_args alias_arg_words chars

    # create an array of function completion triggers, keeping multi-word triggers together
    IFS=$'\n' read -d '' -ra completions < <(complete -p)
    ((${#completions[@]} == 0)) && return 0

	completions=("${completions[@]##complete -* * -}")  # strip all but last option plus trigger(s)
	completions=("${completions[@]#complete -}")        # strip anything missed
	completions=("${completions[@]#? * }")              # strip last option and arg, leaving only trigger(s)
	completions=("${completions[@]#? }")                # strip anything missed

	# create tmpFile for wrapper functions and completions
	tmp_file="$(mktemp -t "${namespace}-${RANDOM}XXXXXX")" || return 1

	IFS=$'\n' read -r completion_loader < <(complete -p -D 2> /dev/null)
	if [[ "${completion_loader#complete }" =~ '-F'[[:space:]]([[:alnum:]_]+)[[:space:]] ]]; then
		completion_loader="${BASH_REMATCH[1]}"
	else
		completion_loader=""
	fi

	# read in "<alias> '<aliased command>' '<command args>'" lines from defined aliases
	# some aliases may have backslashes that needs to be interpreted
	while read -r line
	do
		line="${line#alias -- }"
		line="${line#alias }"
		alias_name="${line%%=*}"
		alias_defn="${line#*=\'}"                   # alias definition
		alias_defn="${alias_defn%\'}"
		alias_cmd="${alias_defn%%[[:space:]]*}"     # first word of alias
		if [[ ${alias_defn} == ${alias_cmd} ]]; then
			alias_args=''
		else
			alias_args="${alias_defn#*[[:space:]]}" # everything after first word
		fi

		# skip aliases to pipes, boolean control structures and other command lists
		chars=$'|&;()<>\n'
		if [[ "${alias_defn}" =~ [$chars] ]]; then
			continue
		fi
		# avoid expanding wildcards
		read -ra alias_arg_words <<< "$alias_args"

		# skip alias if no completion function triggered
		if ! arr::contains "$alias_cmd" "${completions[@]}"; then
			if [[ -n "$completion_loader" ]]; then
				# force loading of completions for the aliased command
				"${completion_loader:?}" "${alias_cmd}"
				# 124 means completion loader was successful
				[[ $? -eq 124 ]] || continue
				completions+=("$alias_cmd")
			else
				continue
			fi
		fi
		new_completion="$(complete -p "$alias_cmd" 2> /dev/null)"

		# create a wrapper inserting the alias arguments - if any
		if [[ -n $alias_args ]]; then
			compl_func="${new_completion/#* -F /}"
			compl_func="${compl_func%% *}"
			# avoid recursive call loops by ignoring our own functions
			if [[ "${compl_func#_"$namespace"::}" == "$compl_func" ]]; then
				compl_wrapper="_${namespace}::${alias_name}"
				echo "function $compl_wrapper {
                        local compl_word=\${2?}
                        local prec_word=\${3?}
                        # check if prec_word is the alias itself. if so, replace it
                        # with the last word in the unaliased form, i.e.,
                        # alias_cmd + ' ' + alias_args.
                        if [[ \$COMP_LINE == \"\$prec_word \$compl_word\" ]]; then
                            prec_word='$alias_cmd $alias_args'
                            prec_word=\${prec_word#* }
                        fi
                        (( COMP_CWORD += ${#alias_arg_words[@]} ))
                        COMP_WORDS=(\"$alias_cmd\" \"${alias_arg_words[*]}\" \"\${COMP_WORDS[@]:1}\")
                        (( COMP_POINT -= \${#COMP_LINE} ))
                        COMP_LINE=\${COMP_LINE/$alias_name/$alias_cmd $alias_args}
                        (( COMP_POINT += \${#COMP_LINE} ))
                        \"$compl_func\" \"$alias_cmd\" \"\$compl_word\" \"\$prec_word\"
                    }" >> "$tmp_file"
				new_completion="${new_completion/ -F $compl_func / -F $compl_wrapper }"
			fi
		fi

		# replace completion trigger by alias
		if [[ -n $new_completion ]]; then
			new_completion="${new_completion% *} $alias_name"
			echo "$new_completion" >> "$tmp_file"
		fi
	done < <(alias -p)
	# shellcheck disable=SC1090
	source "$tmp_file" && command rm -f "$tmp_file"
}
####################################################################
# MAIN
####################################################################
completion::callback::alias
