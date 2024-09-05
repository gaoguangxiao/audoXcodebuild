# 创建文件夹，服务器路径写绝对，因此前缀不可包含用户名。路径要公用，nginx默认路径在www文件夹下
# mkdir /usr/local/var/sjenkins
# echo '创建文件夹'

# 配置服务器路径
SOURCE_PATH=./service/sjenkins

cp -a -f ${SOURCE_PATH} /usr/local/var/

# 替换服务器配置
# 源目录
SOURCE_SSL=./service/ssl
SOURCE_Conf=./service/nginx.conf
#目的目录
DESTINATION_SSL=/opt/homebrew/etc/nginx
DESTINATION_Conf=/opt/homebrew/etc/nginx/nginx.conf

# /usr/local/etc/nginx/nginx.conf
# M1 系统路径
# /opt/homebrew/etc/nginx/nginx.conf

cp -a -f ${SOURCE_SSL} ${DESTINATION_SSL}

# 替换conf文件
cp -a -f ${SOURCE_Conf} ${DESTINATION_SSL}

# 刷新nginx
nginx -s reload

brew services restart nginx