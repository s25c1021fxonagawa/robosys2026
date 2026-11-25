#!/bin/bash
# SPDX-FileCopyrightText: 2026 s25c1021fxonagawa
# SPDX-License-Identifier: BSD-3-Clause

ng () {
    echo "${1}行目が違うよ"
    res=1
}

res=0

dir=$(cd "$(dirname "$0")" && pwd)
cmd="$dir/stdcmd"

### 正常な入力 ###
out=$(printf 'a\nb\n' | "$cmd")
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "$(printf 'a\nb')" ] || ng "$LINENO"

### 空の入力 ###
out=$(printf '' | "$cmd")
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

### 標準出力に余計なメッセージを出していない ###
err=$(printf 'a\n' | "$cmd" 2>&1 >/dev/null)
[ "${err}" = "" ] || ng "$LINENO"

# TODO: 機能を実装したら, 異常な入力(終了ステータスが1になり, 標準出力が空になる)のテストを追加する

[ "$res" = 0 ] && echo OK
exit $res
