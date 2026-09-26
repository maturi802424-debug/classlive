# ClassLive

授業の参加、投票、クイズ、質問、振り返りを扱うアプリです。先生は管理用コードでルームを作り、生徒は5桁のルームコードとニックネームで参加します。投稿管理、教室表示、参加状況のレポートも使えます。参加者にChatGPTアカウントは必要ありません。

## 第三者への引き継ぎとCloudflareへの公開

受け取った運営者が自分のCloudflareアカウントを用意します。GitHub Pagesは静的配信のため、このアプリのD1データベースとサーバー処理をそのまま実行できません。GitHubはソース公開先、Cloudflare Workersは実行先です。

1. Node.js 22.13以上を用意し、`corepack pnpm install --frozen-lockfile` を実行します。
2. `npx wrangler login` で運営者のCloudflareアカウントにログインします。
3. `npx wrangler d1 create classlive` を実行し、表示された `database_id` を控えます。
4. `npm run build` を実行します。
5. `CLOUDFLARE_D1_DATABASE_ID=<database_id> npm run deploy:cloudflare` を実行します。初回だけSQLマイグレーションを順に適用してWorkerを公開します。更新時は新しいSQLだけを適用し、`npx wrangler deploy --config dist/server/wrangler.json` を実行します。
6. `npx wrangler secret put TEACHER_ACCESS_KEY --config dist/server/wrangler.json` で十分長い管理用コードを設定します。設定しないと先生権限は拒否されます。

管理用コードをGitHubや公開画面に書き込まず、先生に安全な方法で共有してください。公開後、先生がルームを作り、別ブラウザで生徒参加を確認してください。授業データの保存期間と削除手順は運営者が決めてください。

## 開発

`npm run dev` でローカル起動します。D1のローカルマイグレーションは `npx wrangler d1 execute site-creator-d1 --local --file drizzle/0000_petite_phantom_reporter.sql` のようにSQLを順に適用します。`npx tsc --noEmit` で型を確認できます。

このソースにはSites用の `.openai/hosting.json` も含まれます。別のSitesプロジェクトで使う場合、元の `project_id` をコピーせず、新規作成したプロジェクトIDを使ってください。
