#!/bin/bash
LOCAL_PATH=$(cd `dirname $0`; pwd)
cd $LOCAL_PATH

###############################################################
#　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　＃ 
# 用法：                                                      #
# ./mp4-to-gif.sh 包含视频的目录　　　　　　　　　　　　　　　　　　 ＃
#                                                            #
#                                                            #
##############################################################
WORK_PATH=$1

echo  ">>进入目录" $WORK_PATH

cd $WORK_PATH

if [ ! -d "./pic/" ];then
mkdir ./pic/
#else
#echo "文件夹已经存在"
fi

if [ ! -d "./gif/" ];then
mkdir ./gif/
#else
#echo "文件夹已经存在"
fi

echo  ">>>搜索文件"

for file in $WORK_PATH/* 
do

if [[ "${file##*.}" == "mp4" ]];
then
  FILE_NAME=${file##*/}
  echo ">>>>发现MP4文件 "   "${file##*/}" "${FILE_NAME%%.*}"
  echo -e "\033[31m为${file##*/}创建全局调色板 " " ${FILE_NAME%%.*}.png\033[0m"
  ffmpeg  -i ${file} -b 568k -r 20 -vf fps=20,scale=320:-1:flags=lanczos,palettegen -y ./pic/"${FILE_NAME%%.*}.png" >/dev/null
  echo -e "\033[31m为${file##*/}生成GIF " " ${FILE_NAME%%.*}.gif\033[0m"
  filters="fps=15,scale=320:-1:flags=lanczos"
  ffmpeg -v warning -i ${file} -i ./pic/${FILE_NAME%%.*}.png -r 15 -lavfi "$filters [x]; [x][1:v] paletteuse" -y ./gif/"${FILE_NAME%%.*}.gif" >/dev/null
fi
done
