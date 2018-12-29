
#podfile的路径
Podfile_URL=http://gitlab.bitautotech.com/wangyong3/podfile/raw/master/Podfile

# 【配置上传到蒲公英相关信息】(可选)
__PGYER_U_KEY="db453c9b267a5cf97f151b7fc67d56a5"
__PGYER_API_KEY="af9710b56122251835eefa1b92bfcd4d"

#工程绝对路径
project_path=$(cd `dirname $0`; pwd)

#工程名
project_name=BitAutoPlus

#scheme名
scheme_name=BitAutoPlus

#打包模式 Debug/Release
development_mode=Release

#build文件夹路径
build_path=${project_path}/Package/build

BUILD_DATETIME=`date '+%Y-%m-%d-%H:%M:%S'`
archivePath=${build_path}/${project_name}${BUILD_DATETIME}.xcarchive

#plist文件所在路径
exportOptionsPlistPath=${project_path}/Package/plist/enterprise.plist

#导出.ipa文件所在路径
exportIpaPath=${project_path}/Package/IPADir/${development_mode}/${BUILD_DATETIME}
#echo "Place enter the number you want to export ? [ 1:app-store 2:enterprise] "
number=2
##
#read number
#while([[ $number != 1 ]] && [[ $number != 2 ]])
#do
#echo "Error! Should enter 1 or 2"
#echo "Place enter the number you want to export ? [ 1:app-store 2:enterprise] "
#read number
#done

# if [ $number == 1 ];then
# development_mode=Release
# exportOptionsPlistPath=${project_path}/exportAppstore.plist
# else
# development_mode=Debug
# exportOptionsPlistPath=${project_path}/exportTest.plist
# fi

echo '///-----------'
echo '/// update Podfile '
echo '///-----------'
curl ${Podfile_URL} > Podfile

echo '///-----------'
echo '/// pod update'
echo '///-----------'
pod update

echo '///-----------'
echo '/// 正在清理工程'
echo '///-----------'
xcodebuild \
clean -configuration ${development_mode} -quiet  || exit


echo '///--------'
echo '/// 清理完成'
echo '///--------'
echo ''

echo '///-----------'
echo '/// 正在编译工程:'${development_mode}
echo '///-----------'
xcodebuild \
archive -workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${archivePath}  -quiet  || exit

echo '///--------'
echo '/// 编译完成'
echo '///--------'
echo ''

echo '///----------'
echo '/// 开始ipa打包'
echo '///----------'
xcodebuild -exportArchive -archivePath ${archivePath} \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit

if [ -e $exportIpaPath/$scheme_name.ipa ]; then
echo '///----------'
echo '/// ipa包已导出'
echo '///----------'
# open $exportIpaPath
else
echo '///-------------'
echo '/// ipa包导出失败 '
echo '///-------------'
fi
echo '///------------'
echo '/// 打包ipa完成  '
echo '///-----------='
echo ''

echo '///-------------'
echo '/// 开始发布ipa包 '
echo '///-------------'

if [ $number == 1 ];then

#验证并上传到App Store
# 将-u 后面的XXX替换成自己的AppleID的账号，-p后面的XXX替换成自己的密码
altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
"$altoolPath" --validate-app -f ${exportIpaPath}/${scheme_name}.ipa -u XXX -p XXX -t ios --output-format xml
"$altoolPath" --upload-app -f ${exportIpaPath}/${scheme_name}.ipa -u  XXX -p XXX -t ios --output-format xml
else

# 上传蒲公英
curl -F "file=@$exportIpaPath/$scheme_name.ipa" \
  -F "uKey=$__PGYER_U_KEY" \
  -F "_api_key=$__PGYER_API_KEY" \
  "http://www.pgyer.com/apiv1/app/upload"

echo "上传 ${exportIpaPath}/${scheme_name}.ipa 包 到 pgyer 成功 🎉 🎉 🎉"

fi

echo '///-------------'
echo '/// 开始备份Podfile '
echo '///-------------'
cp Podfile ${exportIpaPath}
cp podfile.lock  ${exportIpaPath}

exit 0
