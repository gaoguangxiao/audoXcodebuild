exportName=$1
projectDes=$2
serviceURL=$3
project_name=$4
#echo "网页收到："${aimusicDes}

#读取版本号
infolistPath="./build/${project_name}.xcarchive/Info.plist"
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print ApplicationProperties:CFBundleShortVersionString" "${infolistPath}")

#获取提交ID
branchCommitID(){
git rev-parse HEAD
}
CommitID=$(branchCommitID $1)
# echo "编译CommitID："${CommitID}

#获取分支名字
branchCommitName(){
git branch -r --contains ${CommitID}
}
branchName=$(branchCommitName $1)
branchName=${branchName##*/}

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

commitTmpDes="${projectDes}【分支名：${branchName}、版本号：${bundleShortVersion}、打包模式：${development_mode}】${commitMessage}、作者:${commitAuthor}"

#过滤空格
commitTmpDes=${commitTmpDes// /-}
#生成编译描述
echo "Create buildDes：${commitTmpDes}"

cat << EOF > ./${exportName}/ExportInstall.html
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="">
    <meta name="keywords" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>App</title>
</head>
<body>
<br>
    
    <div><h5>App内测版</h5>
    <div> <a href="itms-services://?action=download-manifest&url=${serviceURL}/${exportName}/manifest.plist",align ="middle">安装</a>
    </div>
    <div>
        <img height="300" src="${serviceURL}/${exportName}/ExportUpload.png"/>
        <p>$commitTmpDes</p>
        <p>版本地址：$exportName</p>
    </div>
    
    <div>
        <h2>常见问题</h2>

        <p>无法安装应用<p>
        <a href="${serviceURL}/server.crt">下载CA证书</a>

        <div class="row">问题：无法连接到 "xx.xx.xx.xx"</div>
        <div class="row">解决：【设置 > 通用 > 关于本机 > 证书信任设置】勾选信任</div>
        <br>
        <div class="row">问题：未受信任的企业级开发者</div>
        <div class="row">解决：【设置 > 通用 > 描述文件与设备管理】添加到信任</div>
    </div>
</body>
</html>
EOF
