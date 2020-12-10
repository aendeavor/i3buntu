#!/usr/bin/env bash

# This script serves as a wrapper for
# the installation of all fonts in the
# directory of this script.
# 
# current version - 0.5.0 stable

FONTDIR="${HOME}/.local/share/fonts"

function firacode() {
	(
		local _ret=0
	    mkdir -p "${FONTDIR}/FiraCode"
		cd "${FONTDIR}/FiraCode" || return 1

		for TYPE in Bold Light Medium Regular Retina; do
		    FILE_URL="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${TYPE}.ttf?raw=true"

		    if ! wget -O "FiraCode-${TYPE}.ttf" "${FILE_URL}" -q; then
				_ret=1
			fi 
		done

		# FiraCode Nerd and Mono fonts

		local NERDFONT="FiraCodeNerd"
		local MONOFONT="FiraMono"

		cd "${FONTDIR}" || return 1

		mkdir -p "${NERDFONT}"
		mkdir -p "${MONOFONT}"

		cd "${NERDFONT}" || return 1
		if wget -O "${NERDFONT}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip" -q; then
			unzip -u "${NERDFONT}.zip"
			rm "${NERDFONT}.zip"
		else
			_ret=1
		fi 

		cd "../${MONOFONT}" || return 1
		if wget -O "${MONOFONT}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraMono.zip" -q; then
			unzip -u "${MONOFONT}.zip"
			rm "${MONOFONT}.zip"
		else
			_ret=1
		fi 

		return $_ret
	)
}

function fontawesome() {
	(
		local FONTNAME="FontAwesome"

		cd "$FONTDIR" || return 1
		rm -rf $FONTNAME ${FONTNAME}.zip

		if wget -O ${FONTNAME}.zip "https://github.com/FortAwesome/Font-Awesome/releases/download/5.11.2/fontawesome-free-5.11.2-desktop.zip" -q; then
			unzip ${FONTNAME}.zip
			rm ${FONTNAME}.zip
		else
			return 1
		fi 

		mv "fontawesome-free-5.11.2-desktop" $FONTNAME
	)
}

function get_font() {
	(
		mkdir -p "${FONTDIR}/$1"
		cd "${FONTDIR}/$1" || return 1

		if ! wget -O "$1.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/$2.zip" -q; then
			return 1
		fi 

		unzip -u "$1.zip"
		rm "$1.zip"
	)
}

function test_on_success() {
	if "$@" &>/dev/null; then
	    printf 'successfull.\n'
	else
	    printf 'unsuccessfull.\n'
	fi
}

function install_fonts() {
	[ -d "${FONTDIR}" ] || mkdir -p "${FONTDIR}"

	printf '–> FiraCode family will be installed... '
	test_on_success firacode

	printf '–> FontAwesome will be installed... '
	test_on_success fontawesome

	printf '–> Iosevka will be installed... '
	test_on_success get_font 'IosevkaNerd' 'Iosevka'

	printf '–> Roboto Mono Nerd will be installed... '
	test_on_success get_font 'RobotoMonoNerd' 'RobotoMono'

	echo ''
}

# ! Main

function main() {
	install_fonts
	unset -v FONTDIR
}

main "$@" || exit 1
