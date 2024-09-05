# 创建文件夹，服务器路径写绝对，因此前缀不可包含用户名。路径要公用，nginx默认路径在www文件夹下
# mkdir /usr/local/var/sjenkins
# echo '创建文件夹'

# 配置服务器路径
SOURCE_PATH=./service/sjenkins

cp -a -f ${SOURCE_PATH} /usr/local/var/

# 获取CPU的型号
cpu_model=$(sysctl -n machdep.cpu.brand_string)
 
# /usr/local/etc/nginx/nginx.conf
# M1 系统路径
# /opt/homebrew/etc/nginx/nginx.conf

MAC_TYPE=/opt/homebrew
# 使用grep进行匹配判断
if echo "$cpu_model" | grep -q 'Apple M'; then
    # echo "This is an Apple M chip."
    MAC_TYPE=/opt/homebrew
elif echo "$cpu_model" | grep -q 'GenuineIntel'; then
    # echo "This is an Intel processor."
    MAC_TYPE=/usr/local
else
    # echo "Unknown processor type."
    MAC_TYPE=/usr/local
fi


# 获取CPU的型号
# 源目录
SOURCE_SSL=./service/ssl
SOURCE_Conf=./service/nginx.conf
#目的目录
DESTINATION_SSL=${MAC_TYPE}/etc/nginx
DESTINATION_Conf=${MAC_TYPE}/etc/nginx/nginx.conf



cp -a -f ${SOURCE_SSL} ${DESTINATION_SSL}

# 替换conf文件
cp -a -f ${SOURCE_Conf} ${DESTINATION_SSL}

# 刷新nginx
nginx -s reload

brew services restart nginx