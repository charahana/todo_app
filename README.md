# TODO_APP
## サイト概要
### サイトテーマ
自分のタスクを作成し、他のユーザーのタスクを閲覧、参考に出来るタスク共有のSNS
​
### アプリ概要
ruby on railsで作成したタスク管理アプリです。
Deviseを用いたユーザー認証機能を実装し、ユーザーごとにタスクを管理できるようにしております。CRUD機能を中心に、Webアプリケーションの基本構造を意識して開発しました。
​
### 機能一覧
- ユーザー登録/ログイン機能(Devise)
- タスク作成・一覧表示・編集・削除(CRUD)
- ユーザーごとのタスク管理(user_idで紐付け)
- バリデーション機能
- 他ユーザーのタスク閲覧機能
​
### 工夫した点
- Deviseを用いて認証機能を実装
- タスクとユーザーを紐付けることでデータの整合性を確保
- strong Parametersを使用しセキュリティを意識
- MVC構造を意識し、責務を分離して実装

## 使用技術
- Ruby 3.x
- Ruby on Rails 7.x
- PostgreSQL
- HTML / CSS
- JavaScript（jQuery）
​
## 開発環境
- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby,SQL
- フレームワーク：Ruby on Rails
- JSライブラリ：jQuery
- IDE：Cloud9
​