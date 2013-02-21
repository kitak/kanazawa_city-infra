# KanazawaCity::Infra

石川県金沢市の地図情報基盤APIにアクセスするライブラリです． 
市有施設などの公共データを利用できます． 
APIの詳細については(施設情報の二次利用について)[http://www4.city.kanazawa.lg.jp/11010/opendata/index.html]を参照してください．

## Installation

Add this line to your application's Gemfile:

    gem 'kanazawa_city-infra'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kanazawa_city-infra

## Usage

API呼び出し結果の詳細な項目については(施設情報の二次利用について)[http://www4.city.kanazawa.lg.jp/11010/opendata/index.html]の「地図情報発信基盤API利用マニュアル」を参照してください.
```ruby
require 'kanazawa_city-infra'

# ジャンルの一覧を取得 ジャンル情報が格納された配列を返します
genres = KanazawaCity::Infra.genres

# 施設情報の検索 施設情報が格納されたオブジェクトの配列を返します
fs = KanazawaCity::Infra.facilities(keyword: "まちのり") # キーワード検索

## メソッド呼び出し，ハッシュ，両方の形式で値を取得可能
fs[0].name # => まちのり事務局 
fs[0]['name'] # => まちのり事務局

f = fs[0].detail # 施設の詳細な情報を取得
puts f.summary # 施設の概要

KanazawaCity::Infra.facilities(geocode: "36.5946816,136.6255726,2000") # 範囲検索
KanazawaCity::Infra.facilities(genre: 1) # ジャンルのidで検索 
KanazawaCity::Infra.facilities(genre: genres[0]) # 取得したジャンルのオブジェクトで検索
KanazawaCity::Infra.facilities(genre: ["12-28", "13"]) # 複数のジャンルを指定
KanazawaCity::Infra.facilities(genre: ["1", genres[1]]) # idとオブジェクトを組み合わせることも可能

## 1回の取得件数を10件にする(デフォルト20件, 最大50件)
fs = KanazawaCity::Infra.facilities(genre: 1, count: 10)
## 全ての検索結果を走査する
while fs.has_next?
  fs = fs.next
  pp fs
end
```
取得した情報の細かい絞り込みにはEnumerable#select, Enumerable#detectなどが便利です.

検索結果の施設情報の取得例
```
{
  "id"=>"2007",
  "name"=>"金沢21世紀美術館",
  "address"=>"金沢市広坂1-2-1",
  "url"=>"http://www.kanazawa21.jp/",
  "tel"=>"076-220-2800",
  "coordinates"=>{"latitude"=>36.5608672, "longitude"=>136.6582577},
  "genres"=>
   [{"id"=>2, "name"=>"文化・芸術", "query_id"=>2},
    {"id"=>1,
     "name"=>"観光",
     "subgenre"=>{"id"=>1, "name"=>"美術館・博物館", "query_id"=>"1-1"},
     "query_id"=>1}],
  "detail_url"=>
   "https://infra-api.city.kanazawa.ishikawa.jp/facilities/2007.json?lang=ja"
}
```

施設の詳細な情報の取得例
```
{
 "id"=>"386",
 "name"=>"まちのり事務局",
 "summary"=>
  "● 「まちのり」は一般のレンタサイクルと違い、みんなで自転車をシェアするサービスです。\r\n● まちなかに設置した19ヶ所のサイクルポート（貸出・返却拠点）及びまちのり事務局であれば、どこでも自転車の貸出・返却ができます（貸出場所と違うポートに返却できます）。\r\n● 自転車を借りたら30分以内に、目的地近くのポートに返却してください。",
 "address"=>"金沢市此花町３−２（ライブ１内）",
 "tel"=>"0120-319-047",
 "fax"=>"",
 "email"=>"",
 "opening_hours"=>"9:00～20:00",
 "closed_days"=>"",
 "fee"=>"基本料金　１日200円　１月1,000円　１年9,000円\r\n１回の利用時間が30分を超えると30分ごとに200円が加算",
 "note"=>"",
 "url"=>"http://www.machi-nori.jp/",
 "coordinates"=>{"latitude"=>36.57687, "longitude"=>136.651408},
 "genres"=>[{"id"=>13, "name"=>"まちのり", "query_id"=>13}],
 "zipcode"=>"920-0852",
 "medias"=>{"images"=>[], "videos"=>[], "audios"=>[]}
}
```

取得したジャンル情報の取得例
```
{
 "id"=>"1",
 "name"=>"観光",
 "subgenres"=>
  [{"id"=>1, "name"=>"美術館・博物館", "query_id"=>"1-1"},
   {"id"=>2, "name"=>"歴史・文化施設", "query_id"=>"1-2"},
   {"id"=>3, "name"=>"寺社", "query_id"=>"1-3"},
   {"id"=>4, "name"=>"庭園・公園", "query_id"=>"1-4"},
   {"id"=>5, "name"=>"その他", "query_id"=>"1-5"}],
 "query_id"=>"1"
}
```

ジャンルのid一覧
```
1 観光
  1-1 美術館・博物館
  1-2 歴史・文化施設
  1-3 寺社
  1-4 庭園・公園
  1-5 その他
2 文化・芸術
3 生涯学習
  3-6 生涯学習
  3-7 公民館
4 くらし
  4-8 届け出・証明
  4-9 その他
5 こども
  5-10 児童館
  5-11 児童クラブ
  5-12 保育所
  5-13 その他
6 スポーツ施設
  6-14 体育館
  6-15 プール
  6-16 テニスコート
  6-17 その他
7 福祉・健康
  7-18 保健所・福祉健康センター
  7-19 市立病院
  7-20 その他
8 ビジネス
9 学校
  9-21 市立小学校
  9-22 市立中学校
  9-24 金沢美大
  9-25 市立工業高等学校
10 公園
11 駐車場・駐輪場
  11-26 駐車場
  11-27 駐輪場
12 ふらっとバス
  12-28 此花ルートバス停
  12-29 菊川ルートバス停
  12-30 材木ルートバス停
  12-31 長町ルートバス停
13 まちのり
14 避難所
```

## 備考 
このライブラリから取得できるデータは金沢市から提供されています． 
このライブラリを利用する場合には，(施設情報の二次利用について)[http://www4.city.kanazawa.lg.jp/11010/opendata/index.html]の「施設情報の利用条件等」を確認してください．

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
