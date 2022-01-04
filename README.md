# Pllizm(プリズム)
**人と人との繋がりのあるべき姿を実現する、半匿名型SNSです。**  

**URL: https://www.pllizm.com  (ゲストログイン機能あり)**  

<p align="center">
  <img src="https://user-images.githubusercontent.com/79041840/143382156-8240ea9b-80ae-48b2-89b1-b472d53f2aca.png" />
</p>

# サービス概要と背景
## どのようなサービスか
人と人との繋がりのあるべき姿を実現する半匿名型SNSです。　　

## あるべき姿
前提として、本サービスでは***社会規範***における人と人との繋がりに対するソリューションを提供しています。  
その上で、人と人との繋がり方のあるべき姿を以下のように定義しています。  
「それぞれが自分の思想をありのままの形で発信できる環境で、それに共感してくれる人と共生する。」

## ユーザーが抱える課題
主に以下2つの課題があります。  
①: 多くの人々は自分の本音を自由に発信できていない。  
②: ①により本当の自分を分かってもらいにくかったり、他者の本当の姿を理解しにくかったりしている。

## 課題が生じる原因
前述した課題②が生じる原因は、課題①が発生していることでした。  
つまり、課題①が生じる原因を考える必要があります。  
課題①の原因は、日本における、物事を間接的に伝えることを美徳とする文化や、同調性が強いため出る杭を打つ文化にあると考えます。  
この文化的要因により、自由な発言がしにくいという課題が発生しています。

## 本サービスが提供する解決策
前述した課題①,②に対して、それぞれ以下の解決策を提供しています。  
### ①: 匿名型のSNS  
基本的な機能はTwitterと同様ですが、大きく以下の2点が異なります。  
1) 相互フォローしないとお互いの投稿を見たりリプライしたりできない点。  
2) 基本的に投稿主がフォロワーの誰かわからないように匿名化される点。  

これらの特徴により、Pllizmでは日本の文化的慣習から解放された環境を提供し、自由な発信が可能になります。  
<p align="center">
  <img src="https://user-images.githubusercontent.com/79041840/143383325-0cb5ef84-22cb-4c00-b2da-a52ff24ef27c.png" />
</p>

### ②: リフラクト  
Pllizmでは週に1度、投稿を1つだけ非匿名化することが可能です。  
これをリフラクトと呼びます。  
リフラクト時には誰が誰に対してリフラクトしたのかが通知されます。  
これらに機能により、自分が真に共感する人は誰か明らかになり、またその相手に対しても自分の存在を知ってもらうことができます(逆もまた然りです)。  
<p align="center">
  <img width="32%" src="https://user-images.githubusercontent.com/79041840/143394959-559e643c-e7b2-4bd2-95c8-96bf1b3081ad.png" />
  <img width="32%" src="https://user-images.githubusercontent.com/79041840/143394995-654686a5-a1c2-4a0f-b435-d437c5d8f453.png" />
  <img width="32%" src="https://user-images.githubusercontent.com/79041840/143395005-b4f5cfe8-2448-4e9e-b4be-518333d287b2.png" />
</p>  

以上の方法により、「それぞれが自分の思想をありのままの形で発信できる環境で、それに共感してくれる人と共生する」世界を実現しています。

# 使用技術概略(詳細後述)
- TypeScript
- React
- Ruby 2.7.1
- Ruby on Rails 6.1.4
- MySQL 8.0.26
- Nginx
- Puma
- AWS
  - Route53
  - Amplify
  - ALB
  - VPC
  - EC2
  - RDS
  - S3
  - Cloud Front
  - ACM
- CircleCI
- Docker/Docker-compose

# インフラ構成図
![image](https://user-images.githubusercontent.com/79041840/143372739-fa599880-b9f6-42ed-b089-5a2acf9921b2.png)

# ER図
![image](https://user-images.githubusercontent.com/79041840/144173080-63295412-0664-41bd-acc6-7a0db3cd79ca.png)

# 実装機能一覧
## ユーザー利用機能
- 認証機能
- アカウント情報変更・削除機能
- フォロー機能
- 投稿作成機能
- 投稿削除機能
- いいね機能
- 投稿ロック機能: リフラクト(投稿の非匿名化)されないようにする機能
- リプライ作成機能
- 一連の投稿表示機能
- ユーザー検索機能
- リフラクト機能: バッチ処理, 週に1度、投稿を1つだけ非匿名化できる
- 通知機能: 投稿がいいねされたりリフラクト(投稿の非匿名化)されたりした場合に、通知が表示される
- Route53 による独自ドメイン + SSL化
- レスポンシブ対応

## 非ユーザー利用機能
- puma-socket 通信による Rails の Nginx 配信
- Docker による開発環境の完全コンテナ化
- CircleCI による自動 CIパイプライン構築
  - Front-end: ESLint&prettier
  - Back-end: RSpec, rubocop

# 使用技術詳細
## Front-end: React + TypeScript
``creat-react-app`` をベースに開発。
### 主要ライブラリ等
- ``Redux``: Stateの一元管理するフレームワーク。Redux関連ファイルは、reducksパターン則って管理。
- ``Material-UI``: Google が提供する UI コンポーネントライブラリ。
- ``eslint & prettier``: javascriptに対する静的コード解析。

## Back-end: Rails + Nginx
### 主要gem
- ``devise_token_auth``： APIモードでのdevise。トークン認証を簡単に実装。
- ``aws-fog/carrierwave``: 画像をAWS S3に保存。
- ``rspec``： デファクトスタンダードになっているRubyテスト用フレームワーク。
- ``rubocop-airbnb``： Rubyの静的コード解析。
- ``paranoia``: 論理削除機能の実装に使用。
- ``simplecov``: テストのカバレッジ測定に使用。現時点でカバレッジは99.16%。
- ``whenever``: Railsでcronを管理するために使用。

## Infrastructure
``Docker/docker-compose``
開発環境をすべてDockerコンテナ内で完結。  

``AWS``
Front-end, Back-endのデプロイで使用。

**利用サービス**
- Route53
- Amplify
- ALB
- VPC
- EC2
- RDS
- S3
- Cloud Front
- ACM

``CircleCI``
自動CIパイプラインの構築に使用。

**自動化項目**
- RSpec
- rubocop
- ESLint & prettier

# 各種ドキュメント
- エンティティ一覧: https://crystal-tank-263.notion.site/d5f149299b754566a8e74d004ed8a342?v=819f6cb073b24530b4b2d0bbc5139b42
- 画面一覧: https://crystal-tank-263.notion.site/287f31bf7f064989be8cdae6466d79c5
- API機能一覧: https://crystal-tank-263.notion.site/API-91d6991b3939434ebbc7a6b947bc60ab
