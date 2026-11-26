#!/bin/bash
# SPDX-FileCopyrightText: 2026 s25c1021fxonagawa
# SPDX-License-Identifier: BSD-3-Clause

ng () {
    echo "${1}行目が違うよ"
    res=1
}

res=0

dir=$(cd "$(dirname "$0")" && pwd)
cmd="$dir/quat2euler"

### 正常###
# 回転なし
out=$(echo "0 0 0 1" | "$cmd")
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.000000 0.000000 0.000000" ] || ng "$LINENO"

# z軸まわりに90度(ラジアン)
out=$(echo "0 0 0.7071068 0.7071068" | "$cmd" -p 4)
[ "${out}" = "0.0000 0.0000 1.5708" ] || ng "$LINENO"

# 度数法, x軸まわりに180度
out=$(echo "1 0 0 0" | "$cmd" -d -p 1)
[ "${out}" = "180.0 0.0 0.0" ] || ng "$LINENO"

# ジンバルロック(y軸まわりに90度)
out=$(echo "0 0.7071068 0 0.7071068" | "$cmd" -d -p 3)
[ "${out}" = "0.000 90.000 0.000" ] || ng "$LINENO"

# 3軸の回転を含む値
out=$(echo "0.1 0.2 0.3 0.9" | "$cmd" -d -p 3)
[ "${out}" = "19.440 18.408 40.050" ] || ng "$LINENO"

# 正規化されていないクォータニオン
out=$(echo "0 0 0 2" | "$cmd" -p 1)
[ "${out}" = "0.0 0.0 0.0" ] || ng "$LINENO"

# 複数行
out=$(printf '0 0 0 1\n1 0 0 0\n' | "$cmd" -d -p 0)
[ "${out}" = "$(printf '0 0 0\n180 0 0')" ] || ng "$LINENO"

# カンマ区切り(CSV)
out=$(echo "0,0,0.7071068,0.7071068" | "$cmd" -d -p 1)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.0 0.0 90.0" ] || ng "$LINENO"

# カンマの前後に空白があるCSV
out=$(echo "0, 0, 0.7071068, 0.7071068" | "$cmd" -d -p 1)
[ "${out}" = "0.0 0.0 90.0" ] || ng "$LINENO"

# タブ区切り
out=$(printf '0\t0\t0.7071068\t0.7071068\n' | "$cmd" -d -p 1)
[ "${out}" = "0.0 0.0 90.0" ] || ng "$LINENO"

# -w: w x y zの順で入力(z軸まわりに90度)
out=$(echo "0.7071068 0 0 0.7071068" | "$cmd" -w -d -p 1)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.0 0.0 90.0" ] || ng "$LINENO"

# -w: 回転なし
out=$(echo "1 0 0 0" | "$cmd" --wxyz -p 1)
[ "${out}" = "0.0 0.0 0.0" ] || ng "$LINENO"

# -wとCSVの組み合わせ
out=$(echo "0.7071068,0.7071068,0,0" | "$cmd" -w -d -p 1)
[ "${out}" = "90.0 0.0 0.0" ] || ng "$LINENO"

# 空の入力
out=$(printf '' | "$cmd")
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

### 異常な入力(終了ステータス1, 標準出力は空) ###
for input in "1 2 3" "a b c d" "0 0 0 0" "nan 0 0 1" "inf 0 0 1" "" \
    "1,2,3" "1,,2,3" "1 2 3 4 5" "0 0, 0 1"; do
    out=$(echo "$input" | "$cmd" 2>/dev/null)
    [ "$?" = 1 ] || ng "$LINENO"
    [ "${out}" = "" ] || ng "$LINENO"
done

# エラーの行があっても, 正しい行は出力する
out=$(printf 'x\n0 0 0 1\n' | "$cmd" -p 1 2>/dev/null)
[ "$?" = 1 ] || ng "$LINENO"
[ "${out}" = "0.0 0.0 0.0" ] || ng "$LINENO"

# エラーメッセージは標準エラー出力に出す
err=$(echo "x" | "$cmd" 2>&1 >/dev/null)
[ -n "${err}" ] || ng "$LINENO"

# 正常時は標準エラー出力に何も出さない
err=$(echo "0 0 0 1" | "$cmd" 2>&1 >/dev/null)
[ "${err}" = "" ] || ng "$LINENO"

### 不正なオプション(終了ステータス2) ###
"$cmd" -p 99 < /dev/null > /dev/null 2>&1
[ "$?" = 2 ] || ng "$LINENO"

[ "$res" = 0 ] && echo OK
exit $res
