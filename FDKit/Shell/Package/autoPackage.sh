
#!/bin/sh
# 该脚本使用方法
# 源码地址：
# step 1. 在工程根目录新建Package文件夹，autoPackage.sh放进去;
# step 2. 设置该脚本;
# step 2. cd 该脚本目录，运行chmod +x autoPackage.sh;
# step 3. 终端运行 sh autoPackage.sh;
# step 4. 选择不同选项....
# step 5. Success 🎉 🎉 🎉!
#TODO
# 1. 上传失败重试
# 2. 中间环节失败，放弃后续流程
# 3. 将错误导出到日志
# 4. 企业包增加水印



# ************************* 需要配置 Start ********************************
BitAutoPlusGitLabURL=http://gitlab.bitautotech.com/WP/Mobile/IOS/BitAutoPlus

mail_list="##@##.com,##@##.com"

#工程绝对路径
project_path=$(cd `dirname $0`; pwd)
cd ${project_path}
cd ../
work_path=$(pwd)

#podfile的路径
Podfile_URL=http://##/raw/master/Podfile

# 【配置上传到蒲公英相关信息】(可选)
__PGYER_U_KEY="##"
__PGYER_API_KEY="##"

# 【配置上传到苹果相关信息】(可选)
__APPLE_ID="##"
__APPLE_PASSWORD="##"

#工程名
project_name=BitAutoPlus

#打包模式 Debug/Release
development_mode=Release

#plist文件所在路径
exportOptionsPlistPath=${work_path}/Package/plist/enterprise.plist



if [ ! -n "$1" ] ;then
  echo "Place enter the number you want to export ? [ 1:app-store 2:enterprise] "
  read number
else
    echo "The number input is:$1,[ 1:app-store 2:enterprise]."
    number=$1
fi

while([[ $number != 1 ]] && [[ $number != 2 ]])
do
    echo "Error! Should enter 1 or 2"
    echo "Place enter the number you want to export ? [ 1:app-store 2:enterprise] "
    read number
done


#scheme名
if [ $number == 1 ];then
    exportOptionsPlistPath=${work_path}/Package/plist/app-store.plist
    scheme_name=BitAutoPlusStore
    development_mode=Archive
else
    exportOptionsPlistPath=${work_path}/Package/plist/enterprise.plist
    scheme_name=BitAutoPlus
    development_mode=Release
fi
#build文件夹路径
# build_path=${work_path}/Package/build
BUILD_DATETIME=`date '+%Y-%m-%d-%H:%M:%S'`

logPath=${work_path}/Package/log/${BUILD_DATETIME}.log

build_path=${work_path}/Package/IPADir/${scheme_name}/${development_mode}/${BUILD_DATETIME}
#导出.ipa文件所在路径
exportIpaPath=${build_path}

archivePath=${build_path}/${project_name}${BUILD_DATETIME}.xcarchive

appPath=${archivePath}/Products/Applications/${scheme_name}.app

# ************************* 需要配置 End ********************************

# 打印信息
function printMessageInLogFile() {
  pMessage=$1
  echo '///-----------' >> ${logPath}
  echo "/// ${pMessage}" >> ${logPath}
  echo '///-----------' >> ${logPath}
}

echo
echo '///-----------'
echo '/// Config  '
echo '///-----------'
printMessageInLogFile "Config"
echo "The number input is:$number,[ 1:app-store 2:enterprise]." >> ${logPath}

echo "The 1 is:$0" >> ${logPath}
echo "The 1 is:$1" >> ${logPath}
echo "The 2 is:$2" >> ${logPath}
echo "who am i" >> ${logPath}
who am i >> ${logPath}


echo
echo '///-----------'
echo '/// Git '
echo '///-----------'
printMessageInLogFile "Git"
git clone ${BitAutoPlusGitLabURL}
cd BitAutoPlus
git reset --hard
git clean -fd
git pull
git checkout develop
git log -1 >> ${logPath}
git branch >> ${logPath}


echo '///-----------'
echo '/// update Podfile '
echo '///-----------'
printMessageInLogFile "update Podfile"
curl ${Podfile_URL} > Podfile

echo '///-----------'
echo '/// cat Podfile '
echo '///-----------'
printMessageInLogFile "cat Podfile"
cat Podfile > ./BitAutoPlus/packageInfo
echo '///-----------' >> ${logPath}
cat Podfile >> ${logPath}

echo '///-----------'
echo '/// pod update'
echo '///-----------'
printMessageInLogFile "pod update"
/usr/local/bin/pod update --verbose >> ${logPath}

echo '///-----------' >> ${logPath}
cat Podfile.lock >> ${logPath}

echo '///-----------'
echo '/// 正在清理工程'
echo '///-----------'
printMessageInLogFile "正在清理工程"
xcodebuild \
clean -configuration ${development_mode} -quiet >> ${logPath}


echo '///--------'
echo '/// 清理完成'
echo '///--------'
echo ''
printMessageInLogFile "清理完成"

echo '///-----------'
echo '/// 正在编译工程:'${development_mode}
echo '///-----------'
printMessageInLogFile "正在编译工程 ${development_mode} ${work_path}/${project_name}/${project_name}.xcworkspace"
xcodebuild \
archive -workspace ${work_path}/${project_name}/${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${archivePath} -quiet  >> ${logPath}

echo '///--------'
echo '/// 编译完成'
echo '///--------'
printMessageInLogFile "编译完成"

echo '///----------'
echo '/// 开始ipa打包'
echo '///----------'
printMessageInLogFile "开始ipa打包"
xcodebuild -exportArchive -archivePath ${archivePath} \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet >> ${logPath}

if [ -e $exportIpaPath/$scheme_name.ipa ]; then
    echo '///----------'
    echo '/// ipa包已导出'
    echo '///----------'
    printMessageInLogFile "ipa包已导出"

    # open $exportIpaPath
    echo '///-------------'
    echo '/// 开始发布ipa包 '
    echo '///-------------'
    printMessageInLogFile "开始发布ipa包"

    if [ $number == 1 ];then
        #验证并上传到App Store
        # 将-u 后面的XXX替换成自己的AppleID的账号，-p后面的XXX替换成自己的密码
         altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
         "$altoolPath" --validate-app -f ${exportIpaPath}/${scheme_name}.ipa -u ${__APPLE_ID} -p ${__APPLE_PASSWORD} -t ios --output-format xml >> ${logPath}
         "$altoolPath" --upload-app -f ${exportIpaPath}/${scheme_name}.ipa -u  ${__APPLE_ID} -p ${__APPLE_PASSWORD} -t ios --output-format xml >> ${logPath}
        echo "上传 ${exportIpaPath}/${scheme_name}.ipa 到苹果商店"
    else
        # 上传蒲公英
        curl -F "file=@$exportIpaPath/$scheme_name.ipa" \
        -F "uKey=$__PGYER_U_KEY" \
        -F "_api_key=$__PGYER_API_KEY" \
        "http://www.pgyer.com/apiv1/app/upload" >> ${logPath}
        echo "上传 ${exportIpaPath}/${scheme_name}.ipa 包 到 pgyer 成功 🎉 🎉 🎉"
        printMessageInLogFile "上传 ${exportIpaPath}/${scheme_name}.ipa 包 到 pgyer 成功 🎉 🎉 🎉"
    fi

    echo '///-------------'
    echo '/// 开始备份Podfile 并且查看App'
    echo '///-------------'
    printMessageInLogFile "开始备份Podfile"
    cp Podfile ${exportIpaPath}
    cp podfile.lock  ${exportIpaPath}

    printMessageInLogFile "查看entitlements & version"
    codesign -d --entitlements - ${appPath} >> ${logPath}
    plutil -p ${appPath}/Info.plist | grep CFBundle.*Version >> ${logPath}

    echo '///-------------'
    echo '///发送邮件 '
    echo '///-------------'

    printMessageInLogFile "开始发送邮件"
    cat ${logPath} | /usr/bin/mail -s "打包成功 ${BUILD_DATETIME}"  ${mail_list}
    printMessageInLogFile "发送邮件结束"


else
    echo '///-------------'
    echo '/// ipa包导出失败 '
    echo '///-------------'
    printMessageInLogFile "ipa包导出失败"

    echo '///-------------'
    echo '///发送邮件 '
    echo '///-------------'
    printMessageInLogFile "开始发送邮件"
    cat ${logPath} | /usr/bin/mail -s "打包失败 ${BUILD_DATETIME}"  ${mail_list}
    printMessageInLogFile "发送邮件结束"

fi

echo '///------------'
echo '/// 打包ipa完成  '
echo '///-----------='
printMessageInLogFile "打包ipa完成"





exit 0
