# R4FY
インターンでの開発物を管理するためのリポジトリです。

## 初回起動手順
- [初回起動手順](./docs/%E5%88%9D%E5%9B%9E%E8%B5%B7%E5%8B%95%E6%89%8B%E9%A0%86.md)

## 起動手順
### 一括（基本的に使わない）
```
docker-compose up
```

`-d`オプション付きでバックグラウンド実行。`docker-compose stop`で停止。

### DBエラー時
以下のコマンドでDBを初期化（データが消えるので注意）
```shell
docker-compose run api rails db:migrate:reset
docker-compose run api rails db:seed
```

### 別々に起動したい場合（開発時はこちらを使用）
※別のコンソールタブで実行
```shell
docker-compose up api
docker-compose up web
docker-compose up mail
```
※初回起動時にアクセス許可を求められるが、「許可する」または「はい」を選択する（パブリックの...のチェックボックスは変更しない）。
※`Ctrl + C`で終了。
※mailを終了すると届いたメールは消える（消えないこともある？）。


### フロントシェル（ログとか見るなら）
```
docker-compose run web sh
```
※ここで実行してもポートの設定をしていないのでつながらない（はず）。

## 検証環境・本番環境 起動（開発環境では使用しない）
- [検証環境環境手順](./docs/%E6%A4%9C%E8%A8%BC%E7%92%B0%E5%A2%83%E6%89%8B%E9%A0%86.md)

## ディレクトリ構成（使うところだけ説明）
- `.vscode` ...Visual Studio Code の共通設定を入れています。
- `api` ...Ruby on Rails で動く Web API です。
  - `app`
    - `controllers` ...実装するAPIを入れておくフォルダです。
      - `application_controller.rb` ...APIのベースとなるコントローラーです。エラー時の返却値の定義などを行なっています。
      - `api/v1` ...APIの本体です。
        - `login_controller.rb` ...ログイン機能の例です。
        - `connection_controller.rb` ...ログインチェックの例です。 `before_action :require_login` はログインしていないと使えない機能に付けてください。
    - `models` ...使用するデータの設定などです。
  - `config` ...設定です。ここを書き換えた場合は、Railsの再起動が必要です。
    - `routes.rb` ...APIのルーティングを行なっています。機能を追加する場合は、必ずここを編集する必要があります。
  - `db` ...データベース関連のフォルダです。
- `web` ...Vue.js で画面の表示を制御します。
  - `src`
    - `components` ...ページを構成する部品を入れておきます。
    - `mixins` ...前ページ共通で使えるJavaScriptです。追加する場合は `main.js` を書き換える必要があります。
      - `api.js` ...Web API通信用の関数です。
    - `router/index.js` ...Vue.js 側のルーティング設定です。
    - `views` ...各ページの表示を定義します。
    - `main.js` ...全体を読み込むためのメインとなるファイル（？）です。
    - `App.vue` ...全体に適用する CSS を書くことができます。ここにページを埋め込んで表示しているようなイメージです。
- `docker-compose.yml` ...開発環境で使用するDockerのための定義です。

<details>
<summary>ディレクトリ構成（もう少し詳しく）</summary>

---

※★付きはよく使う場所

```
├─.githooks ...Gitの設定
├─.vscode ...Visual Studio Codeの設定
├─api ...★ Web API
│  ├─app ...本体
│  │  ├─channels ...Action Cableファイル用のディレクトリ
│  │  ├─controllers ...★ 本体
│  │  ├─jobs ...Active Job用のディレクトリ
│  │  ├─mailers ...Action Mailerファイル用のディレクトリ
│  │  ├─models ...★ モデル用のディレクトリ
│  │  └─views ...ビュー用のディレクトリ（今回はVue.jsで画面を生成するので使用しない）
│  ├─bin ...アプリケションを管理する様々なスクリプト用のディレクトリ
│  ├─config ...★ 設定用
│  │  ├─environments ...環境単位の設定ファイル用のディレクトリ
│  │  ├─initializers ...初期化ファイル用のディレクトリ
│  │  └─locales ...辞書ファイル用のディレクトリ（今回はVue.jsで画面を生成するので使用しない）
│  ├─db ...データベース関連のファイル用のディレクトリ
│  │  └─migrate ...自動生成
│  ├─lib ...複数のアプリケーション間で共有するライブラリ用のディレクトリ
│  │  └─tasks ...自分で生成したRakefile用のディレクトリ
│  ├─log ...ログファイル用のディレクトリ
│  ├─public ...Web上に公開するファイル用のディレクトリ（今回はVue.jsで画面を生成するので使用しない）
│  ├─storage ...ファイルのアップロードで保存されるディレクトリ（今回はVue.jsで画面を生成するので使用しない）
│  ├─test ...アプリケーションのテストに使うファイル用のディレクトリ
│  └─tmp ...キャッシュなど、一時的なファイル用のディレクトリ
└─web ...★ 画面用
   ├─public ...アプリケーションの枠
   └─src ...★ 本体
       ├─assets ...静的ファイルを入れておく
       │  └─css ...全体に適用するCSSを入れておく（読み込みは別途必要）
       ├─components ...★ Vue.jsのパーツ
       │  └─layout ...★ Vue.jsのレイアウト
       ├─mixins ...★ 全体に適用するJavaScriptを入れておく（読み込みは別途必要）
       ├─router ...★ パスとファイルを紐づける
       └─views ...★ 画面本体
```

---
</details>

## 処理の流れについて
### 例１）ログイン
1. ブラウザ → Vue.js (index.html) を取得
2. ユーザーがブラウザ上のフォームにログイン情報を入力
3. ユーザーがボタンをクリック → JavaScriptの関数が動き、HTML上のフォーム情報を `localhost:3000/api/v1/login` に送信
4. Ruby on Rails (Web API) 側の `api/config/routes.rb` の情報を元に、`api/app/controller/api/v1/login_controller.rb` の `create` を実行
5. ログイン情報が正しければ `status: "success"` を返す
6. JavaScriptはWeb API側から`status: "success"`が返ってきたことを確認したら、`this.$router.push("/home")`を実行し、ホームのページに表示を切り替える

※内部的に`session_id`を発行し、ログイン情報をブラウザに記録しています。

### 例２）接続確認
1. ブラウザ → Vue.js (index.html) を取得
2. Vue.js 側の `main.js` に書かれた起動時の処理内で `localhost:3000/api/v1/connection` に情報を送信
3. Web API側の `connection_controller.rb` を呼び出し、呼び出し時に `require_login` を実行（継承？元の`ApplicationController`に書かれた処理）
4. `require_login`内でログインチェックを行い、ブラウザ（JavaScript）側に情報を返す

※`localhost:3000/api/v1/connection` に情報を送信する際に`cookie`に保存された`session_id`を送信しています。

## その他のメモ
### CORSについて
- Web APIの呼び出し元を制限する。
- `api/config/initialize/cors.rb` の中の `origins` にサーバーのドメインを書いておく。複数書くことも可能。


### 強制的にRubyのコードをフォーマット
コミット時に自動的に行ないますが、以下のコマンドで全ファイルのフォーマットを強制的に整えます。
```shell
docker-compose run api rubocop -a
```
※ファイル保存時は処理に時間がかかってしまうため設定していません。

### Railsでログ出力を追加（コミット前に消すこと）
```ruby
logger.debug("msg")
```

### データベースについて
- `/api/db/development.sqlite3` にすべて保存されています。
- `DB Browser for SQLite` 等で中のデータを見ることができます

### ローカル用メールサーバーについて
- `docker-compose up mail` で起動
- ブラウザで確認 → http://localhost:1080/#/
- Docker内のネットワークを使用
- `mail:1025`に送信するとメールが届くはず
- Dockerを止めるとメールが消えることがあるので注意
- 設定ファイルは `/api/config/mail.yml`

### DB初期化
`api/db/development.sqlite3` を削除 or 移動

## 参考サイト
### Docker
- [Docker で Rails + Vue + MySQL の環境構築をする方法【2020/09 最新版】 - Qiita](https://qiita.com/Kyou13/items/be9cdc10c54d39cded15#2-dockerfile%E4%BD%9C%E6%88%90)


### Vue.js
- [vue-cli で作成した Vue.js プロジェクトでホットリロードが効かない場合の対処｜アイオーアーキテクト](https://www.io-architect.com/wp/archives/5831)
- [アプリケーションの構造 | Vuex](https://vuex.vuejs.org/ja/guide/structure.html)

### Ruby on Rails
- [【Rails】JWTを利用したログインAPIと認証付きAPIの実装 | Enjoy IT Life](https://nishinatoshiharu.com/rails-jwt-auth-api/)
- [Railsの基礎知識 | Railsドキュメント](https://railsdoc.com/rails_base)
- [Rails /テーブル作成、カラムの追加や削除[備忘録] - Qiita](https://qiita.com/A__Matsuda/items/66a7eefbae36e2fea8e5)
- [Rails テーブルのデータ型について - Qiita](https://qiita.com/s_tatsuki/items/900d662a905c7e36b3d4)
- [railsでのデータの保存、更新、削除の方法　Create,Update,Delete - Qiita](https://qiita.com/new1/items/b33255681c0d91f9bef9)
