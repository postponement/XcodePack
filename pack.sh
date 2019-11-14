#!/bin/bash

#author  liuyanchi

echo $PWD

echo $HOME

var=""
var1=""
timeInterval=0			#时间间隔
tempTime=`date +%s`		#当前时间戳
fimeName=""				#临时文件名


#-------------------删除多余文件-------------------
cd ~

cd Desktop

if [[ ! -d "Payload" ]]; then
	mkdir Payload
fi

filePath=$HOME/Desktop/Payload

cd Payload

read -p "是否删除以前生成的Payload.ipa文件(y/n):" var1
if [[ $var1 == "y" ]]; then

	for file in *; do
		rm -rf $file
	done
else
	for file in *; do
			# time=`date +%H:%M:%S` #当前时间
			timeStamp=`date +%s`
			var=${file:0:7}
			var=$var$timeStamp
			mv $file $var.ipa
		done	
fi

#-------------------寻找项目路径-------------------
cd ~
macName=${HOME##*/}
macName=/Users/$macName/Library/Developer/Xcode/DerivedData

cd $macName

read -p "请输入打包项目名(区分大小写):" var

var=$var-
for file in *; do

	if [[ $file =~ $var ]]; then

		#文件去重 当前时间-文件修改时间
		modifyTime=`stat -f %c $file`
		# echo "modifyTime====$modifyTime : $file"
		currentTime=`date +%s`
		timeInterval=$((currentTime-modifyTime))
		if [[ $tempTime -gt $timeInterval ]]; then
		fimeName=$file
		tempTime=$timeInterval
		fi
	fi
done

macName=$macName/$fimeName/Build/Products

cd ~
cd $macName

if [[ -d "Debug-iphoneos" ]]; then
	macName=$macName/Debug-iphoneos
	cd $macName
else
	echo "$macName"
	echo
 	echo "路径出错,请检查路径"
	exit 1
fi


#-------------------生成IPA文件-------------------
cp -R QEZB.app $filePath

cd ~

cd Desktop

zip -r Payload.zip Payload
mv Payload.zip Payload.ipa
mv Payload.ipa Payload

#删除Payload.zip  QEZB.app
rm -rf Payload.zip

cd Payload
rm -rf QEZB.app

echo "-------------$objc pack success!!-----------------"

exit 0



