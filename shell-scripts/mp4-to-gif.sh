#!/bin/bash
LOCAL_PATH=$(cd `dirname $0`; pwd)
cd $LOCAL_PATH
###############################################################
#　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　＃ 
# 用法：                                                      #
# ./mp4-to-gif.sh 包含视频的目录 　　　　　　　　　　　　　        ＃
# 或                             　　　　　　　　　　　　        ＃
# ./mp4-to-gif.sh 包含视频的目录　输出目录　　　　　　　　　　　　　 ＃
# 即可将该目录下的所有视频文件转换为GIF                            #
#                                                            #
##############################################################
WORK_DIR=$1

echo  ">>进入目录" $WORK_DIR

cd $WORK_DIR


if [ ! -n "$WORK_DIR" ] ;then
    echo -e "\033[35m>>>>请先指定视频目录\033[0m"
    exit
fi

if [ ! -n "$2" ] ;then
    OUT_DIR="./gif/"
else
    OUT_DIR=$2
fi

if [ ! -d "./pic/" ];then
mkdir ./pic/
#else
#echo "文件夹已经存在"
fi

if [ ! -d "$OUT_DIR" ];then
mkdir "$OUT_DIR"
#else
#echo "文件夹已经存在"
fi

echo  ">>>搜索文件"

for file in $WORK_DIR/*
do

if [[ "${file##*.}" == "mp4" ]];
then
  FILE_NAME=${file##*/}
  echo -e "\033[35m>>>>发现MP4文件 ${file##*/}\033[0m"
  echo ""
  echo -e "\033[31m>>>>>为${file##*/}创建全局调色板  ${FILE_NAME%%.*}.png\033[0m"
  echo ""
  filters="fps=20,scale=320:-1:flags=lanczos"
  ffmpeg  -i ${file} -b 568k -r 20 -vf $filters,palettegen -y ./pic/"${FILE_NAME%%.*}.png" >/dev/null 2>&1
  echo -e "\033[31m全局调色板 ${FILE_NAME%%.*}.png 生成完成 <<<<<\033[0m"
  echo ""
  echo -e "\033[31m>>>>>为${file##*/}生成GIF ${FILE_NAME%%.*}.gif\033[0m"
  ffmpeg -v warning -i ${file} -i ./pic/${FILE_NAME%%.*}.png -r 15 -lavfi "$filters [x]; [x][1:v] paletteuse" -y "$OUT_DIR"/"${FILE_NAME%%.*}.gif" >/dev/null
  echo ""  
  echo -e "\033[31m GIF ${FILE_NAME%%.*}.gif 生成完成 <<<<<\033[0m"

fi
done

echo -e "\033[31m删除全局调色板 <<<<\033[0m"
rm -r ./pic
echo -e "\033[31m离开目录 $WORK_DIR <<<<\033[0m"

cd $LOCAL_PATH

