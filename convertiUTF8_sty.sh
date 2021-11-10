# encodage de depart
encodeFrom='ISO-8859-15'

# encodage voulu
encodeTo='UTF-8'

# application du script sur les fichiers *.php
for filename in ` find . -type f -name *.sty`

do  
    # sauvegarde du fichier source
    mv $filename $filename.saveISO

    # ecriture du fichier encode
    iconv -f $encodeFrom -t $encodeTo $filename.saveISO -o $filename
done
