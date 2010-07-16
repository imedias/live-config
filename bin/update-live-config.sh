#!/bin/sh

set -e

_DIRECTORY="${1:-/lib/live/config}"

if [ ! -e "${_DIRECTORY}" ]
then
	echo "E: ${_DIRECTORY} - not found."
	exit 1
fi

if [ ! -x "$(which lsb_release 2>/dev/null)" ]
then
	echo "E: lsb_release - command not found"
	echo "I: lsb_release can be optained from:"
	echo "I:   http://www.linux-foundation.org/en/LSB"
	echo "I: On Debian systems, lsb_release can be installed with:"
	echo "I:   apt-get install lsb-release"
	exit 1
fi

_DISTRIBUTION="$(lsb_release -is | tr [A-Z] [a-z])"
_RELEASE="$(lsb_release -cs | tr [A-Z] [a-z])"

echo "Removing unused scripts..."

case "${_DISTRIBUTION}" in
	debian)
		# Removing ubuntu scripts
		rm -f "${_DIRECTORY}"/*-apport
		rm -f "${_DIRECTORY}"/*-ureadahead

		case "${_RELEASE}" in
		lenny)
			# Removing squeeze and newer scripts
			rm -f "${_DIRECTORY}"/*-gdm3
			rm -f "${_DIRECTORY}"/*-kaboom
			rm -f "${_DIRECTORY}"/*-kde-services
			rm -f "${_DIRECTORY}"/*-keyboard-configuration
			;;

		*)
			# Removing lenny legacy scripts
			rm -f "${_DIRECTORY}"/*-console-common
			rm -f "${_DIRECTORY}"/*-console-setup
			#rm -f "${_DIRECTORY}"/*-gdm
			rm -f "${_DIRECTORY}"/*-kpersonalizer
			;;
		esac
		;;
	ubuntu)
		# Removing debian scripts
		rm -f "${_DIRECTORY}"/*-gdm3
		;;
esac