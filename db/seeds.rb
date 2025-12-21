# db/seeds.rb
puts "=== Seedデータの作成を開始します (環境: #{Rails.env}) ==="

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
  
  # 開発環境用データ作成（元のコードをそのままここに）
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
  genres = ["アクション", "RPG", "アドベンチャー", "シューティング", "パズル", "シミュレーション", "スポーツ", "レーシング", "ストラテジー", "ホラー", "インディー", "オープンワールド", "ローグライク", "カジュアル"]
  
  genres.each do |genre_name|
    group = Group.create!(
      name: genre_name,
      description: "#{genre_name}ジャンルのゲームです。"
    )
    groups << group
    puts "グループ作成: #{group.name}"
  end
  
  # タグ作成（必要に応じてコメントアウト）
  puts "--- タグの作成 ---"
  tags = []
  tag_names = ["グラフィックが綺麗", "ストーリー重視", "アクション爽快", "音楽が良い", "ボリューム満点"]
  
  tag_names.each do |tag_name|
    tag = Tag.create!(name: tag_name)
    tags << tag
    puts "タグ作成: #{tag.name}"
  end
  
  puts "--- 投稿データの作成 ---"
  5.times do |n|  # 開発時は5件で十分
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
  # 本番/評価環境用コード（前回示した安全なコード）
  # ...
  
else
  # test環境など
  puts "[#{Rails.env}環境] テストデータを作成します..."
end

puts "=== 完了 ==="