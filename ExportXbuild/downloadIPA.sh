
exportFilePath=$1
#IPA名称
scheme_name=$2
#描述
commitTmpDes=$3

# 服务器路径
servicePath=/usr/local/var/sjenkins/
# 本机地址
serviceName=localhost
# 证书路径
serverCA=https://${serviceName}/server.crt

echo '*** 正在 制作 plist html png ***'
serviceURL=https://${serviceName}

chmod +x ~/audoXcodebuild/ExportXbuild/manifest.sh
~/audoXcodebuild/ExportXbuild/manifest.sh ${exportFilePath} ${serviceURL}/${exportFilePath}/${scheme_name}.ipa

chmod +x ~/audoXcodebuild/ExportXbuild/createHtml.sh
~/audoXcodebuild/ExportXbuild/createHtml.sh ${exportFilePath} ${commitTmpDes} ${serviceURL}

htmlURL=${serviceURL}/${exportFilePath}/ExportInstall.html

chmod +x ~/audoXcodebuild/ExportXbuild/createQrcode.sh
~/audoXcodebuild/ExportXbuild/createQrcode.sh ${exportFilePath} ${htmlURL}
htmlURLPNG=${serviceURL}/${exportFilePath}/ExportUpload.png
#
echo "Create ExportInstall.html：${htmlURL}"
echo "Create ExportUpload.png：${htmlURLPNG}"
echo '*** 制作 plist html png 完成 ***'

if [ -e ${exportFilePath}/$scheme_name.ipa ];then
echo "*** 开始移动ipa文件 ***"

#将文件移动至服务器目录
mv -v ${exportFilePath} ${servicePath}

echo '*** 进程完成 ***'
else
echo "*** 创建.ipa文件失败 ***"
fi