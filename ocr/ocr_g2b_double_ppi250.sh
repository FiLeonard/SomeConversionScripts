#/bin/bash
 
if [ $# -eq 0 ]
then
	echo "PDF-Datei als ersten Parameter erwartet"
	exit 1
fi

n=0
maxjobs=3
 
# Basisnamen für später merken
pdfbase=$(basename "$1" .pdf)
mkdir -p ./${pdfbase}/unpaper/ocr/ 
chmod -R 777 ./${pdfbase}/

# Extrahiere Bilder a
echo "############################################################################"
echo ""
echo "------------------------> Starting OCR-Script (OCR/Mono/250dpi)"
echo ""
echo "############################################################################"
echo ""
echo "-----------> Converting $1 to PGM images with pdftoppm (default:250ppi)"
echo ""
echo "############################################################################"
echo "############################################################################"

#pdftoppm -gray -r 250 "$1" "./${pdfbase}/${pdfbase}_temp"
cd ${pdfbase}/
# Optimiere die Bilder
for image in ${pdfbase}_temp*
do
	../img_gray_ocr.sh ${image} &
	if (( $(($((++n)) % $maxjobs)) == 0 )) ; then
        echo "Doing $maxjobs jobs!"
		wait # wait until all have finished (not optimal, but most times good enough)
    fi
done
wait

# Fasse einzelne PDFs wieder zusammen
echo "PDFs zusammenfassen"
pdftk unpaper/ocr/pdf_*.pdf output "../${pdfbase}_ocr.pdf"
echo "Fertig!"

# Lösche temporäre Dateien
#read -p "Sollen die temporären Daten gelöscht werden?: (yes?)" check
 
#if [ $check = "yes"]
# then
#    rm pdf_${pdfbase}_temp-*.pdf ${pdfbase}_temp-*
#fi
