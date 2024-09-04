#adhoc包、切项目目录，执行./Xbuildipa.sh

#import sendEmail.py

#工程名
project_name=RSReading

scheme_name=$1

echo '*** scheme ***' $scheme_name

#蒲公英描述 默认正式
buildDes="正式"

#scheme_name=$1
if [ $scheme_name = "RSReading" ]; then
buildDes="服务器环境：正式"
elif [ $scheme_name = "RSReadingAlpha" ]; then
buildDes="服务器环境：正式+alpha"
elif [ $scheme_name = "RSReadingTest" ]; then
buildDes="服务器环境：测试"
else
scheme_name=$project_name
fi

isUppeyer=true
uKey="30bf32a465116034606e89bd9b353ea2"
apikey="a302095f686f173337f3d4da6fe5b0d1"
appKey="5b92ec69d28c211cac8bdd6aa8c922d6"
#打包模式 Debug/Release
development_mode="$2"
#scheme_name=$1
if [ $development_mode = "Debug" ]; then
buildDes=$buildDes+"调试"
elif [ $development_mode = "Release" ]; then
buildDes=$buildDes+"不可调试"
else
development_mode="Debug"
fi

echo '*** scheme end ***' $scheme_name
echo '*** 蒲公英描述 ***' $buildDes

#导出.ipa文件所在路径
timestamp=`date "+%Y%m%d%H%M"`
timesDes=`date "+%Y年%m月%d日%H时%M分%S秒"`
exportFileName=${project_name}_${timestamp}
exportFilePath=${exportFileName}
servicePath=~/Documents/JKIpaService/
serviceName=192.168.51.12
serverCA=https://${serviceName}/server.crt

#plist文件所在路径
exportOptionsPlistPath=./ExportOptions.plist

echo '*** 正在 清理工程 ***'
xcodebuild \
clean -configuration ${development_mode} -quiet  || exit
echo '*** 清理完成 ***'


echo '*** 正在 编译工程 For '${development_mode} ${scheme_name}

#
xcodebuild \
archive -workspace ${project_name}.xcworkspace \
-scheme ${scheme_name} \
-destination 'generic/platform=iOS' \
-configuration ${development_mode} \
-archivePath build/${project_name}.xcarchive -quiet  || exit
echo '*** 编译完成 ***'


echo '*** 正在 打包 ***'
xcodebuild -exportArchive -archivePath build/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportFilePath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit
echo '*** 打包完成 ***'

#读取版本号
infolistPath="./build/${project_name}.xcarchive/Info.plist"
VersionNum=$(/usr/libexec/PlistBuddy -c "print ApplicationProperties:CFBundleShortVersionString" "${infolistPath}")
#提交信息
branchCommitMessage(){
git log --pretty=format:"%s"  -1
}
#获取提交作者
branchCommitAuthor(){
git log --pretty=format:"%an"  -1
}

commitMessage=$(branchCommitMessage $1)
commitAuthor=$(branchCommitAuthor $1)

commitTmpDes="【分支名：${branchName}、版本号：${VersionNum}、打包模式：${development_mode}】${commitMessage}"
buildDes="提交日志：${commitTmpDes}；提交作者:${commitAuthor}"

#过滤空格
buildDes=${buildDes// /-}
#生成编译描述
echo "Create buildDes：${buildDes}"

#将编译的info.plist复制到打包路径一份
echo '*** 正在 制作 plist html png ***'
serviceURL=https://${serviceName}/${exportFilePath}

chmod +x ./ExportXbuild/manifest.sh
./ExportXbuild/manifest.sh ${exportFilePath} ${scheme_name} $project_name ${serviceURL}

chmod +x ./ExportXbuild/createHtml.sh
./ExportXbuild/createHtml.sh ${exportFilePath} ${buildDes} ${serviceURL} ${serverCA}

chmod +x ./ExportXbuild/createQrcode.sh
htmlURL=${serviceURL}/ExportInstall.html
./ExportXbuild/createQrcode.sh ${exportFilePath} ${htmlURL}
echo '*** 制作 plist html png 完成 ***'

htmlURLPNG=${serviceURL}/ExportUpload.png
#生成编译可下载的图片
echo "Create ExportUpload.png：${htmlURLPNG}"

if [ -e ${exportFilePath}/$scheme_name.ipa ];then
echo "*** 开始上传.ipa文件 ***"

#将文件移动至服务器目录
mv -v ${exportFilePath} ${servicePath}

chmod +x ./ExportXbuild/pgyer_upload.sh
./ExportXbuild/pgyer_upload.sh -k $apikey -d $buildDes ${servicePath}/${exportFilePath}/$scheme_name.ipa

echo '*** 进程完成 ***'
else
echo "*** 创建.ipa文件失败 ***"
fi

# 删除build包
if [[ -d build ]]; then
rm -rf build -r
fi

#删除exportFilePath
if [[ -d ${exportFilePath} ]]; then
rm -rf ${exportFilePath} -r
fi

