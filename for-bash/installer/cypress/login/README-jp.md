Character Encoding: "WHITE SQUARE" U+25A1 is □.

[ [英語](README.md) | 日本語 ]

## インストール方法 (Windows)

1. Git bash をインストールします。
    - https://git-scm.com/downloads
	- ダウンロードするインストーラーのファイル名の例： `Git-2.27.0-64-bit.exe`
	- bash のインストールは必須です。 それ以外の設定は任意です
2. Node.js のパッケージを ダウンロード フォルダ `${USERPROFILE}\Downloads` の直下に配置します。
	- https://nodejs.org/ja/download/
	- ダウンロードするインストーラーのファイル名の例： `node-v12.18.3-x64.msi`
	- Node.js のバージョンは、後で実行する シェル スクリプト の中の `g_Node_js_Version` 変数の値です
3. `cypress.env.json` ファイルの内容を編集します。
	- `LogInToken` はログインのトークンがある場所。 値は、`"InCookie"` または `"InLocalStorage"`
		- aws Amplify 環境なら、Amplify.configure に渡す引数の Auth/cookieStorage の有無に合わせます
	- `LogInAccount` と `LogInPassword` にはサインアップしたアカウントを設定してください
4. bash を開いて、１つの シェル スクリプト を実行します。
	- 拡張子が .sh のファイルが シェル スクリプト です
	- フォルダーを右クリックして **Git Bash Here** を選ぶと bash が起動します
	- `./install_Cypress.sh` (Enter) と入力すると シェル スクリプト を実行します
	- `./install_Cypress.sh  clean` (Enter) と入力すると、アンインストールする シェル スクリプト を実行します
	- `install_Cypress.bat` ファイルや `clean.bat` ファイルをダブルクリックして実行することもできます
5. `cypress/integration` に テスト スクリプトがあります。
	- `0_visit.js`: 特定の URL を開きます
	- `1_make_log-in_token.js`: ログインした状態のトークンをファイルに保存します
	- `2_log-in_test.js`: トークンのファイルを使ってログインした状態で簡単な自動テストを実施します
