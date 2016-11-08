#/bin/bash
 
if [ $# -eq 0 ]
then
	echo "Scan-Image is expected as arg"
	exit 1
fi
	mkdir -p unpaper/ocr/
	chmod -R 777 ./
	imgbase=$(basename "$1")
	echo "----------> USING Imagemagick ON $imgbase"
	convert "${imgbase}" -brightness-contrast 0x55 "imk_${imgbase}"
	echo "----------> USING UNPAPER ON $imgbase"
	unpaper --layout double \
		-ni 3 \
		--blackfilter-intensity 40 --blackfilter-scan-depth 500,500 --blackfilter-scan-size 20,20 --blackfilter-scan-step 5,5 --blackfilter-scan-threshold 0.95 \
		--black-threshold 0.3 \
		--deskew-scan-direction left,right,top,bottom --deskew-scan-range 6.0 --deskew-scan-step 0.1 --deskew-scan-size 1000 --deskew-scan-deviation 2.5 \
		--mask-scan-size 50,80 --mask-scan-threshold 0.08 --mask-scan-direction h --mask-scan-step 15,15\
		-mw 10,0 \
		-Bn v,h -Bp 3,3 -Bt 5 \
		--pre-border 100,90,75,60 \
		--overwrite -t pbm --output-pages 2 \
		"imk_${imgbase}" "unpaper/${imgbase}-%02d.pbm"
	rm "imk_${imgbase}"
	
	for unimg in unpaper/${imgbase}*
	do
		unimgbase=$(basename "$unimg")
		echo  "----------> USING TESSERACT ON $unimg"
		tesseract -l eng "$unimg" "./unpaper/ocr/pdf_${unimgbase}" pdf
	done
	#wait
	chmod -R 777 ./
	echo "-------------------------------------> $imgbase is done"
	echo ""
	echo "############################################################################"

