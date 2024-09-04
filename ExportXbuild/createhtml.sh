exportName=$1
projectDes=$2
serviceURL=$3
serviceCA=$4
#echo "网页收到："${aimusicDes}

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
    <div> <a href="itms-services://?action=download-manifest&url=${serviceURL}/manifest.plist",align ="middle">安装</a>
    </div>
    <div>
        <img height="300" src="${serviceURL}/ExportUpload.png"/>
        <p>$projectDes</p>
        <p>版本地址：$exportName</p>
    </div>
    
    <div>
        <h2>常见问题</h2>

        <p>无法安装应用<p>
        <a href="${serviceCA}">下载CA证书</a>

        <div class="row">问题：无法连接到 "xx.xx.xx.xx"</div>
        <div class="row">解决：【设置 > 通用 > 关于本机 > 证书信任设置】勾选信任</div>
        <br>
        <div class="row">问题：未受信任的企业级开发者</div>
        <div class="row">解决：【设置 > 通用 > 描述文件与设备管理】添加到信任</div>
    </div>
</body>
</html>
EOF
