#!/usr/bin/env bash
#
# Description : Ce script simplifie le fichier OPML de Liferea en ne gardant que
# les balises nécessaires pour un fichier OPML standard. Le fichier généré
# peut-être importé dans n'importe quel agrégateur de flux RSS, y compris Liferea.
#
# Liferea est un aggrégateur de flux RSS sous Linux
# https://www.lzone.de/liferea/
# https://github.com/lwindolf/liferea
# OPML : http://dev.opml.org/spec1.html
#
# Usage : ./liferea2simpleOPML.sh
# Pour que le script fonctionne Liferea doit être installé.
# Auteur : Cédric Goby
# Licence : GPL-3+
# Versioning : https://github.com/CedricGoby/rss-liferea2simpleOPML

# Fichier OPML liferea
_feedlist_liferea="$HOME/.config/liferea/feedlist.opml"

# Fichier de sortie OPML simple
_feedlist_simple="liferea2simple.opml"

# Test de la présence du fichier $HOME/.config/liferea/feedlist.opml
if [ ! -f $_feedlist_liferea ]; then
	printf "%s\n" "[ ERREUR ] Le fichier $_feedlist_liferea n'existe pas, arrêt du script :‑/"
	exit 0
fi

# copie du fichier $HOME/.config/liferea/feedlist.opml dans le répertoire courant
cp $_feedlist_liferea $_feedlist_simple

# Suppression des lignes jusqu'à </head> (ligne incluse)
sed -i '1,/<\/head>/d' $_feedlist_simple
# Ajout de la version XML 1.0, de l'encodage UTF-8 et de la version OPML 1.0
sed -i '1i <?xml version="1.0" encoding="UTF-8"?>\n<opml version="1.0">' $_feedlist_simple
# Début du header
sed -i '3i \  <head>' $_feedlist_simple
# Ajout du titre
sed -i '4i \    <title>SimpleOPML List Export</title>' $_feedlist_simple
# Ajout de la date de modification
sed -i '5i \    <dateCreated>'"$(date -R)"'</dateCreated>' $_feedlist_simple
# Ajout du créateur du document
sed -i '6i \    <ownerName>Cédric Goby</ownerName>' $_feedlist_simple
# Ajout de l'adresse email du créateur
sed -i '7i \    <ownerEmail>cedric.goby@inra.fr</ownerEmail>' $_feedlist_simple
# Fin du header
sed -i '8i \  </head>' $_feedlist_simple

# Suppression des flux "PERSO"
sed -i '/<outline title=\"PERSO\"/,/^[[:space:]]\{4\}<\/outline>/d' $_feedlist_simple

# Suppression des outlines "Non lus" et "Importants"
sed -i '/type="rule"/{N;s/\n.*//;};/type="vfolder"/d;/type="rule"/d' $_feedlist_simple
# Suppression des balises "title","description","id","sortColumn","htmlUrl","updateInterval","collapsed", "expanded", "type="folder""
sed -Ei 's/ title="[^"]*"| description="[^"]*"| id="[^"]*"| sortColumn="[^"]*"| htmlUrl="[^"]*"| updateInterval="[^"]*"| collapsed="[^"]*"| expanded="[^"]*"| type="folder"//g' $_feedlist_simple

# Remplacement des caractères hexadecimaux par des caractères UTF-8
sed -i 's/&#xE2;/â/g;s/&#xE0;/à/g;s/&#xE9;/é/g;s/&#xEA;/ê/g;s/&#xE8;/è/g;s/&#xEB;/ë/g;s/&#xEE;/î/g;s/&#xCF;/ï/g;s/&#xD4;/ô/g;s/&#x9C;/œ/g;s/&#xDB;/û/g;s/&#xF9;/ù/g;s/&#xFC;/ü/g;s/&#xE7;/ç/g;s/&#xC2;/Â/g;s/&#xC0;/À/g;s/&#xC9;/É/g;s/&#xCA;/Ê/g;s/&#xC8;/È/g;s/&#xCB;/Ë/g;s/&#xCE;/Î/g;s/&#xCF;/Ï/g;s/&#xD4;/Ô/g;s/&#x8C;/Œ/g;s/&#xDB;/Û/g;s/&#xD9;/Ù/g;s/&#xDC;/Ü/g;s/&#xC7;/Ç/g;s/&#x2013;/-/g' $_feedlist_simple

