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
  puts "[本番環境] 必須データとテスト投稿を安全に投入します..."
  
  # 1. テストレビュアー用ユーザーを作成（存在しない場合のみ）
  test_user = User.find_or_create_by!(email: "reviewer@example.com") do |user|
    user.name = "テストレビュアー"
    user.password = "password123"
    user.password_confirmation = "password123"
  end
  puts "✅ テストユーザー: #{test_user.email} (password: password123)"
  
  # 2. 必須グループ（ジャンル）を作成（存在しない場合のみ）
  required_genres = ["アクション", "RPG", "アドベンチャー", "シューティング", "パズル"]
  
  required_genres.each do |genre_name|
    Group.find_or_create_by!(name: genre_name) do |group|
      group.description = "#{genre_name}ジャンルのゲームです。"
    end
    puts "✅ グループ確認: #{genre_name}"
  end
  puts "✅ 必須グループ作成完了: #{required_genres.join(', ')}"
  
  # 3. 投稿データがなければ作成（最大3件まで）
  if Post.count == 0
    puts "📝 テスト投稿を作成します..."
    
    demo_posts = [
      {
        title: "ソラリア5：星の継承者",
        platform: "ソラリア5",
        rate: 4.5,
        body: "グラフィックが非常に美しく、ストーリーも感動的でした。キャラクターの成長過程が丁寧に描かれていて、プレイヤーとして感情移入できました。特にエンディングは思わず涙が止まりませんでした。",
        play_time: "50時間",
        difficulty: "普通",
        recommend_level: 5
      },
      {
        title: "ユニットシフト：次元の狭間", 
        platform: "ユニットシフト",
        rate: 3.5,
        body: "パズル要素とアクションが見事に融合しています。頭を使いつつも爽快感がある稀有なゲームです。難易度調整も細かく設定でき、幅広いプレイヤーにおすすめできます。",
        play_time: "20時間",
        difficulty: "難しい",
        recommend_level: 3
      },
      {
        title: "エーテルギア：天空の遺産",
        platform: "エーテルギア",
        rate: 5.0,
        body: "音楽が素晴らしく、ゲームの世界観を引き立てています。BGMだけでプレイする気分が盛り上がります。キャラクターボイスも豪華で、声優陣の演技力に圧倒されました。",
        play_time: "100時間以上",
        difficulty: "簡単",
        recommend_level: 5
      }
    ]
    
    groups = Group.all
    
    demo_posts.each do |post_data|
      post = Post.create!(
        user: test_user,
        group: groups.sample,
        title: post_data[:title],
        platform: post_data[:platform],
        rate: post_data[:rate],
        body: post_data[:body],
        play_time: post_data[:play_time],
        difficulty: post_data[:difficulty],
        recommend_level: post_data[:recommend_level],
        created_at: rand(1..30).days.ago
      )
      puts "✅ 投稿作成: #{post.title} (評価: #{post.rate}★)"
    end
    puts "✅ 合計 #{Post.count}件の投稿を作成しました"
  else
    puts "⚠️  既に投稿データが存在します (#{Post.count}件)。新規投稿は作成しません。"
  end
  
  # 4. サマリー表示
  puts ""
  puts "📊 データサマリー:"
  puts "   ユーザー数: #{User.count}名"
  puts "   グループ数: #{Group.count}個"
  puts "   投稿数: #{Post.count}件"

else
  puts "[#{Rails.env}環境] シード処理をスキップ"
end

puts "=== 完了 ==="
