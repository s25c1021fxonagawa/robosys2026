# robosys2026

[![test](https://github.com/s25c1021fxonagawa/robosys2026/actions/workflows/test.yml/badge.svg)](https://github.com/s25c1021fxonagawa/robosys2026/actions/workflows/test.yml)

標準入力から1行ずつ読み込み, 処理した結果を標準出力に出力するコマンド`stdcmd`です.

<!-- TODO: 機能を実装したら, コマンドが何をするのかをここに具体的に書く -->

## インストール

```
$ git clone https://github.com/s25c1021fxonagawa/robosys2026.git
$ cd robosys2026
```

## 使い方

```
$ printf 'a\nb\n' | ./stdcmd
a
b
```

- 入力は1行につき1つのデータとして扱います.
- 結果は標準出力に, エラーメッセージは標準エラー出力に出力します.

### 終了ステータス

| 値 | 意味 |
| --- | --- |
| `0` | 正常終了 |
| `1` | 処理できない入力があった |

## テスト

```
$ ./test.bash
OK
```

## 動作環境

- OS: Ubuntu 24.04 LTS
- Python: 3.10, 3.11, 3.12, 3.13

GitHub Actionsで上記の環境でテストしています.

## ライセンス

- このソフトウェアパッケージは, 3条項BSDライセンスの下, 再頒布および使用が許可されます.
- © 2026 s25c1021fxonagawa
