# 执行./Jenkins.sh test
# 将Jenkins获取的服务器配置【test、online】
# 转换为 Xcode 命令可识别的 打包系统【RSReadingTest、RSReading】

# 获取服务器环境
appChannel=$1
echo '*** 服务器环境 ***' $appChannel

#打包系统 默认正式
scheme_name=$project_name
if [ $appChannel = "test" ]; then
scheme_name=RSReadingTest
elif [ $appChannel = "online" ]; then
scheme_name=RSReading
elif [ $appChannel = "alpha" ]; then
scheme_name=RSReadingAlpha
fi

sh Xbuildipa.sh $scheme_name $2



