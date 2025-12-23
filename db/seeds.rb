# db/seeds.rb
puts "=== Seedデータの作成を開始します (環境: #{Rails.env}) ==="

# =====================================
# 管理者アカウント（全環境共通）
# =====================================
puts "--- 管理者アカウントの作成 ---"
Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.password = "password"
  admin.password_confirmation = "password"
end
puts "管理者作成: admin@example.com"

case Rails.env
when 'development'
  puts "[開発環境] テストデータをリセットします..."

  # 依存関係順に削除
  Comment.destroy_all
  Like.destroy_all
  PostTag.destroy_all
  Tag.destroy_all
  Post.destroy_all
  Group.destroy_all
  User.destroy_all

  puts "--- ユーザーの作成（開発環境）---"
  users = []
  10.times do |n|
    user = User.create!(
      name: "ゲーマー#{n + 1}",
      email: "gamer#{n + 1}@example.com",
      password: "password",
      password_confirmation: "password"
    )
    users << user
    puts "ユーザー作成: #{user.name}"
  end

  puts "--- グループ（ジャンル）の作成 ---"
  groups = []
  genres = ["アクション", "RPG", "アドベンチャー", "シューティング", "パズル",
            "シミュレーション", "スポーツ", "レーシング", "ストラテジー",
            "ホラー", "インディー", "オープンワールド", "ローグライク", "カジュアル"]

  genres.each do |genre_name|
    group = Group.create!(
      name: genre_name,
      description: "#{genre_name}ジャンルのゲームです。"
    )
    groups << group
    puts "グループ作成: #{group.name}"
  end

  puts "--- タグの作成 ---"
  tags = []
  tag_names = ["グラフィックが綺麗", "ストーリー重視", "アクション爽快", "音楽が良い", "ボリューム満点"]

  tag_names.each do |tag_name|
    tag = Tag.create!(name: tag_name)
    tags << tag
    puts "タグ作成: #{tag.name}"
  end

  puts "--- 投稿データの作成 ---"
  5.times do |n|
    post = Post.create!(
      user: users.sample,
      group: groups.sample,
      title: "開発テスト投稿 #{n + 1}",
      platform: ["ソラリア5", "ユニットシフト"].sample,
      rate: rand(1.0..5.0).round(1),
      body: "これは開発環境用のテスト投稿 #{n + 1} です。",
      play_time: "#{rand(10..100)}時間",
      difficulty: ["簡単", "普通", "難しい"].sample,
      recommend_level: rand(3..5)
    )
    puts "投稿作成: #{post.title}"
  end

when 'production'
  puts "[本番環境] 管理者アカウントのみ作成"

else
  puts "[#{Rails.env}環境] シード処理をスキップ"
end

puts "=== 完了 ==="
