<?php
function request_by_curl($remote_server, $post_string) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $remote_server);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array ('Content-Type: application/json;charset=utf-8'));
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    // 线下环境不用开启curl证书验证, 未调通情况可尝试添加该代码
    // curl_setopt ($ch, CURLOPT_SSL_VERIFYHOST, 0);
    // curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, 0);
    $data = curl_exec($ch);
    curl_close($ch);
    return $data;
}

date_default_timezone_set('PRC');//更改中国时区
$createTime=$argv[1];//获取构建时间
$downloadpngTxt=$argv[2];//获取构建内容
$downloadUrl="https://appstoreconnect.apple.com";//获取HTML
$sendTime=date('H时i分s秒', time());//获取当前时间
//a8edf08012d52d7f58a7967085183cc1d9739ecca369eebe0e302c1ea895b33b
//0b8c85ce6834801e0e18a7a30568eedeebeca71db9c1030d6070f985869f6b0e 测试
$webhook = "https://oapi.dingtalk.com/robot/send?access_token=a8edf08012d52d7f58a7967085183cc1d9739ecca369eebe0e302c1ea895b33b";
$title="下载测试版";
$message="## ${createTime}开始上传：\n > #### 描述：${downloadpngTxt} \n > #### [下载页](${downloadUrl}) \n > ##### ${sendTime}发布 \n";
 $data = array ('msgtype' => 'markdown',
     'markdown' => array ('title' => $title,'text' => $message),
     'at' => array ('atMobiles' => '122','atUserIds' => 'user123','isAtAll' => false));
// 文本类型
//$message="小熊音乐测试下载地址：\n $downloadpngUrl\n";
//$data = array ('msgtype' => 'text','text' => array ('content' => $message));

$data_string = json_encode($data);
$result = request_by_curl($webhook, $data_string);
echo $result;
?>

