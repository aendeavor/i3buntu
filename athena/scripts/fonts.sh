#!/usr/bin/env bash

# This script serves as a wrapper for the
# installation of all fonts in the direc-
# tory of this script.

# author		Georg Lauterbach
# version		0.6.0 unstable

FDIR="${HOME}/.local/share/fonts"
FC="FiraCode"
FCNF="FiraCodeNerd"
FCMF="FiraMono"
FA="FontAwesome"

mkdir -p "${FDIR}/${FC}" "${FDIR}/${FCNF}" "${FDIR}/${FCMF}"

cd "${FDIR}/${FC}" || exit 1
for TYPE in Bold Light Medium Regular Retina; do
	wget -q -O\
		"FiraCode-${TYPE}.ttf"\
		"https://github.com/tonsky/FiraCode/blob/master/\
		distr/ttf/FiraCode-${TYPE}.ttf?raw=true"
done

cd "${FDIR}/${FCNF}" || exit 1
if wget -q -O\
	"${FCNF}.zip"\
	"https://github.com/ryanoasis/nerd-fonts/releases/\
	download/v2.0.0/FiraCode.zip"
then
	unzip -u "${FCNF}.zip"
	rm "${FCNF}.zip"
fi 

cd "${FDIR}/${FCMF}" || exit 1
if wget -q -O\
	"${FCMF}.zip"\
	"https://github.com/ryanoasis/nerd-fonts/releases/\
	download/v2.0.0/FiraMono.zip"
then
	unzip -u "${FCMF}.zip"
	rm "${FCMF}.zip"
fi 

rm -rf "${FDIR:?}/${FA}" "${FDIR:?}/${FA}.zip"
cd "$FDIR" || exit 1
if wget -q -O\
	"${FA}.zip"\
	"https://github.com/FortAwesome/Font-Awe\
	some/releases/download/5.11.2/fontawesom\
	e-free-5.11.2-desktop.zip"
then
	unzip ${FA}.zip
	rm ${FA}.zip
	mv "fontawesome-free-5.11.2-desktop" $FA
fi 

unset FONTDIR FC FCNF FCMF FA
