Character Encoding: "WHITE SQUARE" U+25A1 is □.

# Takakiri 作成スニペット

スニペットのバージョン管理をここで行っています。

[ [英語](README.md) | 日本語 ]


## 一覧

- for-bash
	- base
		- [bashlib](for-bash/base/bashlib/Example_without_inc.sh) - 効率よくデバッグもできる bash のシェル スクリプト ファイルの基本部分
	- [git_clone_commit](for-bash/git_clone_commit/git_clone_commit.sh) - 特定のコミットの Git クローン
	- installer
		- cypress - E2E 自動テスト ツール
			- [base](for-bash/installer/cypress/base/install_Cypress.sh)
			- [+ log in](for-bash/installer/cypress/login/install_Cypress.sh)
		- [Node.js](for-bash/installer/Node_js/install_Node_js.sh)
		- Visual Studio Code
			- [base](for-bash/installer/VisualStudioCode/base/install_VisualStudioCode.sh)
			- [+ TypeScript](for-bash/installer/VisualStudioCode/TypeScript/install_TypeScript_VSCode.sh)


## インストール方法 (Windows)

1. Git bash をインストールします。
    - https://git-scm.com/downloads
	- ダウンロードするインストーラーのファイル名の例： `Git-2.27.0-64-bit.exe`
	- bash のインストールは必須です。 それ以外の設定は任意です
2. Node.js のパッケージを ダウンロード フォルダ `${USERPROFILE}\Downloads` の直下に配置します。
	- https://nodejs.org/ja/download/
	- ダウンロードするインストーラーのファイル名の例： `node-v12.18.3-x64.msi`
	- Node.js のバージョンは、後で実行する シェル スクリプト の中の `g_Node_js_Version` 変数の値です
	- 一部の シェル スクリプト は、実行したときの エラー メッセージ に表示された場所に配置することが必要です
3. bash を開いて、Takakiri 作成スニペットの中の１つの シェル スクリプト を実行します。
	- 拡張子が .sh のファイルが シェル スクリプト です
	- フォルダーを右クリックして **Git Bash Here** を選ぶと bash が起動します
	- `./__FileName__.sh` (Enter) と入力すると シェル スクリプト を実行します
	- `run_*.bat` ファイルをダブルクリックして実行することもできます
