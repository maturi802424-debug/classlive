# ClassLive

[最新版のソース一式をダウンロード](./ClassLive-source-v2.zip)し、展開してから以下の手順に従ってください。公開サイト: https://classlive-kazukun.maturi802424.chatgpt.site （AIの利用には運営者のAPIキー設定が必要です）。

授業の参加、投票、クイズ、質問、振り返りを扱うアプリです。先生はルームを作り、生徒はコードとニックネームで参加します。先生の画面には投稿管理、教室表示、参加状況のレポートがあります。

## AI機能

- 授業テーマと進行メモから、先生が確認して使う問い・投票・クイズ・ミッションの案を作成
- 投稿とリアクションから、先生向けに教室の話題を整理
- 授業レポートの文章案を作成
- 授業終了後、生徒自身の投稿と振り返りから短い助言を作成

AI機能はボタンを押したときだけ呼び出します。先生の分析には最大40件の投稿本文が送られます。生徒向けには本人の投稿と入力した振り返りを送ります。名前は送信しませんが、本文に個人情報を書けば送信されます。アプリ上にその旨を表示しています。APIリクエストは `store:false` を指定します。回数制限はルーム・利用者ごとです。AIの文章は成績や能力の判定に使用しないでください。

## 第三者への引き継ぎとCloudflareへの公開

このリポジトリを受け取る運営者が自分の Cloudflare アカウントと OpenAI API キーを用意します。GitHub Pages は静的配信のため、このアプリの D1 データベースとサーバー側AI処理をそのまま実行できません。GitHub はソース公開先、Cloudflare Workers は実行先です。

1. Node.js 22.13 以上を用意し、`corepack pnpm install --frozen-lockfile` を実行します。
2. `npx wrangler login` で運営者の Cloudflare アカウントにログインします。
3. `npx wrangler d1 create classlive` を実行し、表示された `database_id` を控えます。
4. `npm run build` を実行します。
5. `CLOUDFLARE_D1_DATABASE_ID=<database_id> npm run deploy:cloudflare` を実行します。スクリプトはビルド済み設定に D1 ID を反映し、SQL マイグレーションを順に適用して Worker を公開します。再実行時は適用済みマイグレーションをスキップする仕組みがないため、データベースの初期作成時のみ使ってください。更新時は新しい SQL だけを適用し、`npx wrangler deploy --config dist/server/wrangler.json` を実行します。
6. `npx wrangler secret put TEACHER_ACCESS_KEY --config dist/server/wrangler.json` で十分長い管理用コードを設定します。管理用コードは先生に安全な方法で共有します。**公開運用にはこの設定が必須です。未設定なら先生権限は拒否されます。**
7. `npx wrangler secret put OPENAI_API_KEY --config dist/server/wrangler.json` で、運営者本人の OpenAI API キーを設定します。設定しない場合、授業機能は使えますがAIボタンは設定不足を表示します。必要なら `OPENAI_MODEL` も Worker の環境変数で変更できます。既定は `gpt-5.4-mini-2026-03-17` です。

管理用コードとAPIキーを GitHub、`.env`、公開画面に書き込まないでください。APIキーの利用料は運営者のアカウントに請求されます。公開後、先生が管理用コードでルーム作成し、別ブラウザで生徒参加を確認してください。授業データの保存期間と削除手順は運営者が運用前に決めてください。

## 開発

`npm run dev` でローカル起動します。D1 のローカルマイグレーションは `npx wrangler d1 execute site-creator-d1 --local --file drizzle/0000_petite_phantom_reporter.sql` のように各SQLを順に適用します。`npx tsc --noEmit` で型を確認できます。

このソースには ChatGPT Sites 用の `.openai/hosting.json` も含まれます。別の Sites プロジェクトで使う場合は、元の `project_id` をコピーせず、その環境で新規作成したプロジェクトIDを使ってください。Sites の ChatGPT サインインを先生認証に使う場合だけ、Sites 側の実行環境に `SITES_CHATGPT_AUTH=enabled` を設定します。Cloudflare 直接配信では `TEACHER_ACCESS_KEY` を必ず設定してください。
