#!/bin/bash
# archive and migrate
# author yaokun

#set -ex

date=$(date +'%Y%m%d')
date2=$(date +'%Y%m')
dir="/data/orabak/tmsdata"
bakdir="/data/ossfs/tms/oracle/${date2}"

# 进行tar归档备份文件
function pack_to_tar() {
    if ls ${dir}/tmsbak_"${date}"*.dmp 1> /dev/null 2>&1;then
        echo "文件存在，开始归档"
        cd "${dir}" || exit
        tar zcf tmsbak_"${date}".tar.gz tmsbak_"${date}"*.dmp
        echo "归档完成"
    else
        echo "No such directory"
        exit 1 
    fi
}

# 创建oss中相应文件夹
function mkdir_to_oss() {
    if [ ! -d "${bakdir}" ];then
        echo "No such directory"
        mkdir "${bakdir}"
    else
        echo "Directory exists"
    fi
}

# 传输到oss存储
function trans_to_oss {
    cp tmsbak_"${date}".tar.gz "${bakdir}"/
    if [ $? -eq 0 ]; then
        echo "====move ok!===="
    else
        echo "====move failed!===="
        exit 1
    fi
}

# 清理文件
function delete_files() {
    echo "delete files"
    rm -f tmsbak_"${date}"*
}

function main() {
    pack_to_tar
    mkdir_to_oss
    trans_to_oss
    delete_files
}
main
