#!/usr/bin/env bash
function help {
    echo "-j Q               对jpeg格式图片进行图片质量因子为Q的压缩"
    echo "-r R               对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩成R分辨率"
    echo "-w font_size text  对图片批量添加自定义文本水印"
    echo "-p text            统一添加文件名前缀，不影响原始文件扩展名"
    echo "-s text            统一添加文件名后缀，不影响原始文件扩展名"
    echo "-c                 将png/svg图片统一转换为jpg格式图片"
    echo "-h                 帮助文档"
}

# 对jpeg格式图片进行图片质量压缩
function Jpegcompress {
    Q=$1 # 质量因子
    for i in *;do
        type=${i##*.} # 删除最后一个.及左边全部字符
        if [[ ${type} != "jpeg" ]]; then continue; fi;
        convert "${i}" -quality "${Q}" "${i}"
        echo "the quality of ${i} is compressed."
    done
}

# 对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function Resolutioncompress {
    R=$1
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        convert "${i}" -resize "${R}" "${i}"
        echo "the resolution of ${i} is resized."
    done
}

# 对图片批量添加自定义文本水印
function Watermark {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        convert "${i}" -pointsize "$1" -fill black -gravity center -draw "text 10,10 '$2'" "${i}"
        echo "${i} is watermarked with $2."
    done
}

# 批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
function Prefix {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        mv "${i}" "$1""${i}"
        echo "${i} is prefixed and renamed to $1${i}"
    done
}
function Suffix {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        filename=${i%.*}$1"."${type}
        mv "${i}" "${filename}"
        echo "${i} is is suffixed renamed to ${filename}"
    done
}

# 将png/svg图片统一转换为jpg格式图片
function Conversion {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        filename=${i%.*}".jpg"
        convert "${i}" "${filename}"
   	echo "${i} is transformed to ${filename}"
    done
}

while [ "$1" != "" ];do
case "$1" in
    "-j")
        Jpegcompress "$2"
        exit 0
        ;;
    "-r")
        Resolutioncompress "$2"
        exit 0
        ;;
    "-w")
        Watermark "$2" "$3"
        exit 0
        ;;
    "-p")
        Prefix "$2"
        exit 0
        ;;
    "-s")
        Suffix "$2"
        exit 0
        ;;
    "-c")
        Conversion
        exit 0
        ;;
    "-h")
	help
	exit 0
	;;
esac
done
