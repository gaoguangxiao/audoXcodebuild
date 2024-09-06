## 掌握
1.配置本地nginx并支持ssl。
2.ipa安装配置以及下载网页
3.配置Jenkins

## 流程
1.brew安装nigix
2.在home目录git clone【必须】
3.`config.conf`文件用于生成自签名证书，生成目录位于user目录。将server.crt证书放于/service/sjenkins
4.执行config.sh命令初始化配置


Xbuildipa.sh文件放于项目目录

对项目进行编译，归档、导出

1、制作ipa下载的网页到导出目录

downloadIPA.sh：移动ipa文件夹到服务器

createhtml.sh：创建html文件
manifest.sh读取项目版本号、提交信息等功能

