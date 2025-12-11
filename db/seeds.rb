# db/seeds.rb

# -----------------------------
# ジャンル（Group）
# -----------------------------
# 重複削除（名前が同じものは1件だけ残す）
Group.select(:name).distinct.each do |g|
  Group.where(name: g.name).offset(1).destroy_all
end

groups = [
  "アクション",
  "RPG（ロールプレイング）",
  "シューティング",
  "シミュレーション",
  "アドベンチャー",
  "スポーツ",
  "パズル"
]

groups.each do |group_name|
  Group.find_or_create_by(name: group_name)
end

# -----------------------------
# タグ（Tag）
# -----------------------------
# 重複削除
Tag.select(:name).distinct.each do |t|
  Tag.where(name: t.name).offset(1).destroy_all
end

tags = [
  "RPG",
  "アクション",
  "オープンワールド",
  "シミュレーション",
  "ホラー",
  "パズル",
  "オンライン",
  "ソロプレイ",
  "名作",
  "神グラフィック"
]

tags.each do |tag_name|
  Tag.find_or_create_by(name: tag_name)
end

puts "ジャンルとタグの初期データを作成しました。"
