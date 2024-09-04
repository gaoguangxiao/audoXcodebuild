timestamp=$1
qrcodeTxt=$2

qrencode -o ./${timestamp}/ExportUpload.png -s 18 ${qrcodeTxt}
