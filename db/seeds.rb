# frozen_string_literal: true

# db/seeds.rb を以下のように一時的に変更
puts "=== Seedデータの作成を開始します (環境: #{Rails.env}) ==="

# 管理者アカウント（全環境共通）
puts "--- 管理者アカウントの作成 ---"
Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.password = "password"
  admin.password_confirmation = "password"
end
puts "管理者作成: admin@example.com"

# =====================================
# 本番環境でも開発環境と同じデータを作成
# =====================================
puts "[本番環境] 開発環境と同じテストデータを作成します..."

# 依存関係順に削除（db:resetで行うのでコメントアウト）
# Comment.destroy_all
# Like.destroy_all
# PostTag.destroy_all
# Post.destroy_all
# Tag.destroy_all
# Group.destroy_all
# User.destroy_all

# -------------------------------
# ユーザー作成（開発環境と同じ）
# -------------------------------
puts "--- ユーザーの作成（10名）---"
users = []
10.times do |n|
  user = User.find_or_create_by!(email: "gamer#{n + 1}@example.com") do |u|
    u.name = "ゲーマー#{n + 1}"
    u.password = "password"
    u.password_confirmation = "password"
    u.created_at = rand(1..365).days.ago
  end
  users << user
  puts "ユーザー作成: #{user.name} (#{user.email})"
end

# -------------------------------
# グループ（ジャンル）の作成
# -------------------------------
puts "--- グループ（ジャンル）の作成（10ジャンル）---"
groups = {}
genres = [
  { name: "アクション", description: "アクション要素がメインのゲームです。" },
  { name: "RPG", description: "役割を演じながら成長していくゲームです。" },
  { name: "アドベンチャー", description: "探索や物語を楽しむゲームです。" },
  { name: "シューティング", description: "銃撃戦がメインのゲームです。" },
  { name: "パズル", description: "思考力を試すパズルゲームです。" },
  { name: "シミュレーション", description: "現実をシミュレートするゲームです。" },
  { name: "スポーツ", description: "スポーツ競技を題材にしたゲームです。" },
  { name: "レーシング", description: "レースやドライブを楽しむゲームです。" },
  { name: "ストラテジー", description: "戦略や計画性が重要なゲームです。" },
  { name: "ホラー", description: "恐怖やサスペンスを楽しむゲームです。" }
]

genres.each do |genre|
  group = Group.find_or_create_by!(name: genre[:name]) do |g|
    g.description = genre[:description]
  end
  groups[genre[:name]] = group
  puts "グループ作成: #{group.name}"
end

# -------------------------------
# タグ作成
# -------------------------------
puts "--- タグの作成（15タグ）---"
tags = []
tag_names = [
  "グラフィックが綺麗", "ストーリー重視", "アクション爽快", "音楽が良い", "ボリューム満点",
  "やり込み要素あり", "初心者向け", "上級者向け", "マルチプレイ可", "無料プレイ可",
  "課金要素あり", "感動した", "笑える", "怖い", "癒やされる"
]
tag_names.each do |tag_name|
  tag = Tag.find_or_create_by!(name: tag_name)
  tags << tag
  puts "タグ作成: #{tag.name}"
end

# -------------------------------
# テスト投稿作成（開発環境と同じ10投稿）
# -------------------------------
puts "--- 投稿データの作成（10投稿）---"

demo_posts = [
  # アクション
  {
    title: "星の継承者",
    group_name: "アクション",
    platform: "ソラリア5",
    rate: 4.5,
    body: "アクション要素が非常に爽快で、コンボシステムが複雑ながらも習得しやすいです。ボス戦が特に見応えがあり、グラフィックも美しいです。武器の種類が豊富で、戦闘スタイルを自由にカスタマイズできます。",
    play_time: "50時間",
    difficulty: "普通",
    recommend_level: 5,
    tags: ["アクション爽快", "グラフィックが綺麗", "やり込み要素あり"],
    created_at: 30.days.ago + rand(0..720).minutes
  },
  # RPG
  {
    title: "天空の遺産",
    group_name: "RPG",
    platform: "エーテルギア",
    rate: 5.0,
    body: "キャラクター育成システムが深く、スキルツリーや装備カスタマイズに多くの時間を費やせます。ストーリーも感動的で、キャラクター同士の関係性が丁寧に描かれています。クエスト数が多く、やり込み要素満載です。",
    play_time: "100時間以上",
    difficulty: "簡単",
    recommend_level: 5,
    tags: ["ストーリー重視", "ボリューム満点", "感動した", "やり込み要素あり"],
    created_at: 7.days.ago + rand(0..720).minutes
  },
  # アドベンチャー
  {
    title: "次元の狭間",
    group_name: "アドベンチャー",
    platform: "ユニットシフト",
    rate: 3.5,
    body: "謎解き要素が豊富で、ストーリーが非常に魅力的です。探索するたびに新たな発見があり、世界観に引き込まれます。キャラクターの掛け合いも面白く、物語を進めるのが楽しいです。",
    play_time: "20時間",
    difficulty: "難しい",
    recommend_level: 3,
    tags: ["ストーリー重視", "笑える", "探索楽しい"],
    created_at: 15.days.ago + rand(0..720).minutes
  },
  # シューティング
  {
    title: "ネオンライト",
    group_name: "シューティング",
    platform: "ハイパーキューブX",
    rate: 4.0,
    body: "銃の種類が豊富で、それぞれの特性が明確です。マルチプレイが特に楽しく、チーム戦術も重要です。グラフィックが美しく、近未来の都市がリアルに描かれています。",
    play_time: "40時間",
    difficulty: "普通",
    recommend_level: 4,
    tags: ["マルチプレイ可", "アクション爽快", "グラフィックが綺麗"],
    created_at: 2.days.ago + rand(0..720).minutes
  },
  # パズル
  {
    title: "パズルワンダーランド",
    group_name: "パズル",
    platform: "ユニットシフト",
    rate: 4.5,
    body: "シンプルなルールながら、非常に奥深いパズルゲームです。ステージごとに異なるメカニックが導入され、飽きさせません。BGMがリラックスでき、長時間プレイしても疲れません。",
    play_time: "30時間",
    difficulty: "簡単",
    recommend_level: 5,
    tags: ["癒やされる", "初心者向け", "音楽が良い"],
    created_at: 10.days.ago + rand(0..720).minutes
  },
  # シミュレーション
  {
    title: "田舎暮らし",
    group_name: "シミュレーション",
    platform: "ポケットリンク",
    rate: 4.1,
    body: "のんびりとした農場経営が楽しめます。作物の成長を見守るだけで癒やされます。天候や季節の影響もリアルで、戦略的な経営が必要です。",
    play_time: "60時間",
    difficulty: "超簡単",
    recommend_level: 4,
    tags: ["癒やされる", "初心者向け", "やり込み要素あり"],
    created_at: 5.days.ago + rand(0..720).minutes
  },
  # スポーツ
  {
    title: "サバイバル",
    group_name: "スポーツ",
    platform: "ハイパーキューブX",
    rate: 4.3,
    body: "チーム戦術が重要で、スポーツ要素と戦略性が融合しています。キャラクターごとの特長が明確で、役割分担が楽しめます。オンライン対戦がスムーズで、マッチングも早いです。",
    play_time: "200時間以上",
    difficulty: "激ムズ",
    recommend_level: 4,
    tags: ["マルチプレイ可", "上級者向け", "やり込み要素あり"],
    created_at: 90.days.ago + rand(0..720).minutes
  },
  # レーシング
  {
    title: "レーシングエクストリーム",
    group_name: "レーシング",
    platform: "ポケットリンク",
    rate: 3.8,
    body: "操作感が良く、車両の挙動がリアルです。コースデザインも多様で、様々な環境でのレースが楽しめます。カスタマイズ要素が豊富で、自分の好みの車に改造できます。",
    play_time: "25時間",
    difficulty: "普通",
    recommend_level: 4,
    tags: ["グラフィックが綺麗", "初心者向け", "アクション爽快"],
    created_at: 1.day.ago + rand(0..720).minutes
  },
  # ストラテジー
  {
    title: "戦場の指揮官",
    group_name: "ストラテジー",
    platform: "ソラリア5",
    rate: 4.8,
    body: "戦略性が非常に高く、ユニットの組み合わせや地形を活用する必要があります。キャンペーンが長く、ストーリーも面白いです。マルチプレイのバランス調整が良く、公平な対戦が楽しめます。",
    play_time: "80時間",
    difficulty: "難しい",
    recommend_level: 5,
    tags: ["やり込み要素あり", "上級者向け", "マルチプレイ可"],
    created_at: 45.days.ago + rand(0..720).minutes
  },
  # ホラー
  {
    title: "呪いの館",
    group_name: "ホラー",
    platform: "エーテルギア",
    rate: 4.2,
    body: "サウンドデザインが秀逸で、常に緊張感が保たれます。ストーリーが不気味で、謎解き要素も楽しめます。怖がりな人にはおすすめできませんが、ホラー好きにはたまらない作品です。",
    play_time: "15時間",
    difficulty: "難しい",
    recommend_level: 4,
    tags: ["怖い", "ストーリー重視", "音楽が良い"],
    created_at: 60.days.ago + rand(0..720).minutes
  }
]

# 既存の投稿を削除（find_or_create_byの代わり）
Post.destroy_all
PostTag.destroy_all

demo_posts.each_with_index do |post_data, index|
  # 投稿グループを取得（ジャンル名で指定）
  group = groups[post_data[:group_name]]

  post = Post.create!(
    user: users.sample,
    group: group,
    title: post_data[:title],
    platform: post_data[:platform],
    rate: post_data[:rate],
    body: post_data[:body],
    play_time: post_data[:play_time],
    difficulty: post_data[:difficulty],
    recommend_level: post_data[:recommend_level],
    published: true,
    created_at: post_data[:created_at],
    updated_at: post_data[:created_at] + rand(0..240).minutes
  )

  # 指定されたタグを付与
  if post_data[:tags]
    tag_objects = tags.select { |tag| post_data[:tags].include?(tag.name) }
    post.tags << tag_objects if tag_objects.any?
  end

  puts "投稿作成 #{index + 1}/10: #{post.title}"
  puts "  → ジャンル: #{post.group.name}"
  puts "  → ユーザー: #{post.user.name}"
  puts "  → 投稿日時: #{post.created_at.strftime('%Y/%m/%d %H:%M')}"
  puts "  → タグ: #{post.tags.pluck(:name).join(', ')}" if post.tags.any?

  # コメントをランダムに追加（0-8件）
  comment_count = rand(0..8)
  if comment_count > 0
    comment_users = users.sample(comment_count)
    comment_users.each_with_index do |comment_user, i|
      comment_time = post.created_at + rand(1..72).hours + rand(0..59).minutes
      Comment.create!(
        post: post,
        user: comment_user,
        body: "これは#{['素晴らしい', '面白い', '興味深い', '刺激的', '感動的'].sample}レビューですね！#{['私もプレイしました', '参考になります', '購入を検討します'].sample}",
        created_at: comment_time,
        updated_at: comment_time
      )
    end
    puts "  → コメント: #{comment_count}件追加"
  end

  # いいねをランダムに追加（0-9件）
  like_count = rand(0..9)
  if like_count > 0
    like_users = users.sample(like_count)
    like_users.each do |like_user|
      like_time = post.created_at + rand(1..168).hours + rand(0..59).minutes
      Like.create!(
        post: post,
        user: like_user,
        created_at: like_time
      )
    end
    puts "  → いいね: #{like_count}件追加"
  end
end

# --- コミュニティ作成 ---
# --- コミュニティカテゴリ作成 ---
community_categories = [
  "雑談",
  "攻略情報",
  "フレンド募集",
  "クラン/ギルド募集",
  "その他"
]

categories = {}

community_categories.each do |name|
  categories[name] = Category.find_or_create_by!(name: name)
end

puts "コミュニティカテゴリ作成完了"

community1_owner = users.sample
community2_owner = users.sample

community1 = Community.create!(
  name: "ゲーム雑談コミュニティ",
  description: "好きなゲームについて自由に語り合いましょう。",
  owner_id: community1_owner.id,
  category_id: categories["雑談"].id,
  is_public: true,
  approval_type: [:auto, :manual].sample # ランダムに自動承認 or 承認制
)

community2 = Community.create!(
  name: "攻略情報共有コミュニティ",
  description: "ボス攻略やビルド相談など攻略情報メイン。",
  owner_id: community2_owner.id,
  category_id: categories["攻略情報"].id,
  is_public: true,
  approval_type: [:auto, :manual].sample
)

puts "コミュニティ作成完了"

# --- メンバー登録（必ず作成者を含める）---
[ [community1, community1_owner], [community2, community2_owner] ].each do |community, owner|
  # まずオーナーを必ず参加
  CommunityMembership.find_or_create_by!(
    community_id: community.id,
     user_id: owner.id
  ) do |m|
      m.status = :approved
    end


  # 他のメンバーを追加（オーナー除く）
  (users - [owner]).sample(3).each do |user|
    CommunityMembership.find_or_create_by!(community: community, user: user) do |m|
      # 自動承認なら approved、承認制なら pending
      m.status = community.auto? ? "approved" : "pending"
    end
  end
end

puts "メンバー登録完了"

# --- トピック作成 ---
topic1 = Topic.create!(
  community_id: community1.id,
  user_id: community1.owner_id,
  title: "最近ハマっているゲームは？",
  body: "ジャンル問わず語ってください！"
)

topic2 = Topic.create!(
  community_id: community2.id,
  user_id: community2.owner_id,
  title: "このダンジョンの攻略方法を知りたいです",
  body: "詰まっているのでアドバイスください！"
)

puts "トピック作成完了"

# --- コメントテンプレ作成 ---
topic1_comments = [
  "それ自分もやってます！めちゃくちゃ面白いですよね！",
  "気になってたゲームなので感想助かります！",
  "積みゲーに入ってるので背中押されました！",
  "神ゲーだと思います。サントラも最高でした。"
]

topic2_comments = [
  "〇〇のスキルを取るとかなり楽になります！",
  "まずは防御を固めるのがおすすめです。",
  "属性耐性を揃えると一気に突破できますよ！",
  "フレンドと協力すると攻略が楽になります！"
]

# --- トピックコメント作成（複数種類！）---
# --- トピックコメント作成（被りなし・時間順を考慮）---

# topic1
topic1_created = topic1.created_at || Time.current

topic1_comments.shuffle.each_with_index do |comment, i|
  time = topic1_created + (i + 1).hours + rand(0..50).minutes

  TopicComment.create!(
    topic_id: topic1.id,
    user_id: users.sample.id,
    body: comment,
    created_at: time,
    updated_at: time
  )
end

# topic2
topic2_created = topic2.created_at || Time.current

topic2_comments.shuffle.each_with_index do |comment, i|
  time = topic2_created + (i + 1).hours + rand(0..50).minutes

  TopicComment.create!(
    topic_id: topic2.id,
    user_id: users.sample.id,
    body: comment,
    created_at: time,
    updated_at: time
  )
end


puts "トピックコメント作成完了"

puts "=== コミュニティ機能 seed 作成完了 ==="

puts "=== Seed処理完了 ==="
puts "ユーザー数: #{User.count}, グループ数: #{Group.count}, 投稿数: #{Post.count}"
puts "タグ数: #{Tag.count}, コメント数: #{Comment.count}, いいね数: #{Like.count}"

# コミュニティ関連も追加
puts "コミュニティ数: #{Community.count}"
puts "コミュニティメンバーシップ数: #{CommunityMembership.count}"
puts "トピック数: #{Topic.count}"
puts "トピックコメント数: #{TopicComment.count}"
