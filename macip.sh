# #!/bin/bash
# ip=$(ifconfig | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}')
# echo $ip

#!/bin/bash
# ip=$(curl -s http://ipinfo.io/ip)
# 或者使用wget命令
# ip=$(wget -qO- http://ipinfo.io/ip)
# echo $ip

#!/bin/sh
local_ip=$(ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:")
echo "${local_ip}"
# echo "${local_ip}" | pbcopy
