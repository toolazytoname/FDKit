#!/usr/bin/expect
spawn ssh UserName@***.***.***.***
expect "*password:"
send " \r"
expect "*#"
# send "/bin/sh  /Users/yiche/weichao/Package/autoPackage.sh \r"
send "launchctl start com.BitAutoPlus.autoPackageCalendar \r"
interact

