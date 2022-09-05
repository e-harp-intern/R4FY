# 検証環境用ビルドスクリプト（WSL上で実行：使えない場合は手動 or windows用スクリプト作成）

# Vue.js のビルド
docker-compose run web npm run build

# Rails の public 以下を全消去
ls ./api/public | grep -v -E "robots.txt" | xargs rm -rf

# ビルドした内容をコピー
cp -r ./web/dist ./api/
mv ./api/public/robots.txt ./api/dist/robots.txt
rm -rf ./api/public
mv ./api/dist ./api/public
