#工程名
project_name=Hanpusen
#scheme名
scheme_name=Hanpusen

isUppeyer=true
uKey="30bf32a465116034606e89bd9b353ea2"
apikey="a302095f686f173337f3d4da6fe5b0d1"
#打包模式 Debug/Release
development_mode=Release

#plist文件所在路径
exportOptionsPlistPath=./ExportOptions.plist

#导出.ipa文件所在路径
timestamp=`date "+%Y-%m-%d-%H-%M-%S"`
exportFilePath=~/Desktop/${project_name}_${timestamp}

echo '*** 正在 清理工程 ***'
xcodebuild \
clean -configuration ${development_mode} -quiet  || exit
echo '*** 清理完成 ***'


echo '*** 正在 编译工程 For '${development_mode}
xcodebuild \
archive -workspace ${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath build/${project_name}.xcarchive -quiet  || exit
echo '*** 编译完成 ***'


echo '*** 正在 打包 ***'
xcodebuild -exportArchive -archivePath build/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportFilePath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit

# 删除build包
if [[ -d build ]]; then
rm -rf build -r
fi

if [ -e $exportFilePath/$scheme_name.ipa ];
then
echo "*** .ipa文件已导出 ***"
cd ${exportFilePath}

#此处上传分发应用
if [ $isUppeyer ];
then
echo "*** 开始上传.ipa文件 ***"
RESULT=$(curl -F "file=@$exportFilePath/$scheme_name.ipa" -F "uKey=$uKey" -F "_api_key=$apikey" -F "publishRange=2" http://www.pgyer.com/apiv1/app/upload)
echo "*** .ipa文件上传成功 ***"
else
echo "***仅仅打包***"
fi

else
echo "*** 创建.ipa文件失败 ***"
fi
echo '*** 打包完成 ***'


