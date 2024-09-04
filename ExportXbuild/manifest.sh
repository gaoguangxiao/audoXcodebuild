#读取打包的配置信息
exportName=$1
ipa_name=$2
project_name=$3
serviceURL=$4
infolistPath="./build/${project_name}.xcarchive/Info.plist"
#echo "****打包配置信息的路径：${infolistPath}"

#读取bundleId
bundleID=$(/usr/libexec/PlistBuddy -c "print ApplicationProperties:CFBundleIdentifier" "${infolistPath}")
#读取build版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print ApplicationProperties:CFBundleShortVersionString" "${infolistPath}")
#读取展示版本号
bundleVersion=$(/usr/libexec/PlistBuddy -c "print ApplicationProperties:CFBundleVersion" "${infolistPath}")
#读取APP的名称
displayName=$(/usr/libexec/PlistBuddy -c "print SchemeName" "${infolistPath}")
#拷贝APPIcon到指定的地方
#cp "${WORKSPACE}/Release-iphoneos/${SCHEMECA}.app/AppIcon60x60@3x.png" "/xxx/${SCHEMECA}_AppIcon60x60@3x.png"

#echo "bundleID:${bundleID}"
#echo "bundleShortVersion:${bundleShortVersion}"
#echo "bundleVersion:${bundleVersion}"
#echo "displayName:${displayName}"

cat << EOF > ./${exportName}/manifest.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>items</key>
	<array>
		<dict>
			<key>assets</key>
		   	<array>
				<dict>
					<key>kind</key>
					<string>software-package</string>
					<key>url</key>
					<string>${serviceURL}/${ipa_name}.ipa</string>
				</dict>
			</array>
			<key>metadata</key>
			<dict>
				<key>bundle-identifier</key>
				<string>${bundleID}</string>
				<key>bundle-version</key>
				<string>${bundleShortVersion}</string>
				<key>kind</key>
				<string>software</string>
				<key>title</key>
				<string>${displayName}</string>
			</dict>
		</dict>
	</array>
</dict>
</plist>
EOF
