赤恐竜	http://akakyouryuu.com/

シーン管理をするマクロ集

もしも使いたい人がいたなら好きに使っていい
改変、再配布は自由
使用を明記する必要も報告する必要もない
けど報告をくれるとうれしい

マウスカーソル自動移動は
サークル煌明のMoveMouseCursorPluginがあれば
それをつかう


出来ること
	フェイトやおれつばのようなシーン毎のスキップを可能にする
	もちろん通常のスキップとも併用可
	その他フラグ管理、一度選択した選択肢の色変え、回想モード
	用のマクロも用意
	注意して欲しいのは、ロードでシーンに飛んでいるため
	回想モードはサブルーチンとしてはつかえないこと

やっていること
	該当のシーンのセーブをあらかじめ取っておいて、ロード後に
	変数のつじつまを合わせることで実現
	具体的にはf.checklinkと前の選択肢に戻るの記録,履歴をバックして
	ロード後に戻している。
	
よくありそうな質問
スキップしますかにいいえと答えると、画面がぱかぱかする
->http://hpcgi1.nifty.com/gutchie/wifky/wifky.pl?p=%BB%CD%CA%FD%BB%B3%CF%C3+-+%BE%AE%A5%CD%A5%BF#p2.5
これのせい、実際に使うときは注意
--------------------------------------------------------------------------- 
使っている変数
f.checklink	:@lkを使うとそのリンクのテキストを辞書のキーにして選択を記録する
sf.checklink	:@lkを使うとそのリンクのテキストを辞書のキーにして選択を記録する
sf.checkread	:シーンラベルの二文字目からを辞書のキーにしてシーンを読んだか記録する
		 ただし、シーンの最初以外にもセーブ可能ラベルをおくために
		 *XXX_AAAや*XXX_AAA_BBBはXXXとして記録されるので
		 シーンの最初のラベルには_を使ってはいけない
sf.sceneskip	:シーンスキップをするかどうか(0または1)
内部で使っている変数 
f.scene_skip
f.scene_skip_stoage
f.scene_skip_target
f.scene_storage
f.scene_target
global.scene
---------------------------------------------------------------------------- 
つかえるタグ
---------------------------------------------------------------------------- 
flow		本編にジャンプする、既に既読シーンの場合は
		スキップ確認画面を表示し、次の、または前のシーンに
		ジャンプできる
		sf.sceneskipが0ならこの機能はオフになる
		回想モード中もオフになる		
属性名
outline		:スキップ確認画面でシーンのあらすじを説明する
		 なくてもよい
storage 	:実際の本編が書かれたファイル
target		:実際の本編が書かれたラベル
backstorage	:スキップ確認画面で戻るを選んだときのジャンプ先のファイル
		 デフォルトでは現在のファイル
backtarget	:スキップ確認画面で戻るを選んだときのジャンプ先のラベル
skipstorage	:スキップ確認画面でスキップを選んだときのジャンプ先のファイル
		 デフォルトでは現在のファイル
skiptarget	:スキップ確認画面でスキップを選んだときのジャンプ先のラベル
disable		:シーンスキップをするかどうか
		 選択肢など、スキップするとまずいシーンでtrueを指定する
		 デフォルトではfalse
---------------------------------------------------------------------------- 
rm	flowタグのskipstorage,skiptargetに指定した次のシーンにジャンプする
	同時に今のシーンのラベルの二文字目からを辞書のキーにしてsf.checkreadに記録する
	ただし当然シーンの最初から、終りまでの間にもセーブ可能ラベルをおき
	たいだろうから、その時はシーンの最初のラベルを*XXXとした場合
	*XXX_AAAや、*XXX_AAA_BBBのようにする
	http://hpcgi1.nifty.com/gutchie/wifky/wifky.pl?p=%BB%CD%CA%FD%BB%B3%CF%C3+-+%A5%BB%A1%BC%A5%D6%B2%C4%C7%BD%A4%CA%A5%E9%A5%D9%A5%EB%A4%CE%BC%AB%C6%B0%C0%B8%C0%AE
	で配っているAutoLabeling2.lzhを使うといいと思う
	条件によって次のシーンが変わる場合は下記の属性を指定する
storage		:次のシーンのファイル名
target		:次のシーンのラベル名
---------------------------------------------------------------------------- 
lk		一度選択したものは色を変えて選択肢を表示する
		また、リンクのテキストを辞書のキーにして
		f.checklinkに記録する
		なので変数に使えない文字列はリンクにしてはいけない
		選択肢が表示された時点で今のシーンを既読にする
属性名
storage		:ジャンプ先のファイル
target		:ジャンプ先のラベル
text		:リンクにするテキスト
x		:x座標
y		:y座標
---------------------------------------------------------------------------- 
scene		回想モードに入るためのリンクを表示する
		指定したシーンが未読なら何もしない
属性名
read_storage	:シーンに入る前の準備をするサブルーチンのあるファイル
read_target	:シーンに入る前の準備をするサブルーチンラベル
x		:x座標
y		:y座標
target		:ロードするシーン(*はいらない)
---------------------------------------------------------------------------- 
scene_back	回想後にジャンプする場所を設定する、
		あらかじめ設定しておくこと
属性名
storage		:回想終了後にジャンプするファイルを指定
target		:回想終了後にジャンプするラベルを指定
---------------------------------------------------------------------------- 
rmm	回想モードに戻る
	回想中にこのタグを通ると
	scene_backで設定した場所にジャンプする
	必ず@rmより先におく
---------------------------------------------------------------------------- 

例
scenes.ks(フロウチャート)---------------------------------------------------
*start
ここで右クリックの設定など開始処理をする

*シーン1|シーン1
@flow  storage=01.ks target=*シーン1 backtarget=*start skiptarget=*選択肢1
*選択肢1|選択肢1
@flow outline="" storage="01.ks" target="*選択肢1" disable=true
*シーン2|シーン2
@flow  storage=01.ks target=*シーン2 backtarget=*選択肢1 skiptarget=*選択肢2
*選択肢2|選択肢2
@flow outline="" storage="01.ks" target="*選択肢2" disable=true
*シーン3|シーン3
@flow  storage=01.ks target=*シーン3 backtarget=*選択肢2 skiptarget=*end
*シーン4|シーン4
@flow  storage=01.ks target=*シーン4 backtarget=*選択肢2 skiptarget=*end

*end
ここで終了処理をする

scene_mode.ks(回想モード)-------------------------------------------------------
*scene_mode
@scene_back storage=scene_mode.ks target=*scene_mode
その他背景等の設定

@scene read_storage=scene_mode.ks read_target=*jump_scene x=0 y=100 target=シーン1
@scene read_storage=scene_mode.ks read_target=*jump_scene x=0 y=220 target=選択肢2
@s

*jump_scene
回想シーンに入る前の準備
メニュー、右クリックの設定など
@return

01.ks(本編)-------------------------------------------------------------------- 

*シーン1|

ここはシーン1です
*シーン1_1|
ここはシーン1です
*シーン1_2|
ここはシーン1です
*シーン1_3|
ここはシーン1です
*シーン1_4|
ここはシーン1です
@rm

*選択肢1|

@lk storage=scenes.ks target=シーン2 text=シーン2に飛ぶ
@s

*シーン2|

ここはシーン2です
@rmm
@rm

*選択肢2|

@lk storage=scenes.ks target=シーン2 text=シーン3に飛ぶ
@lk storage=scenes.ks target=シーン2 text=シーン4に飛ぶ
@s

*シーン3|

ここはシーン3です
@rmm
@rm

*シーン4|

ここはシーン4です
@rmm
@rm

---------------------------------------------------------------------------- 
使い方
first.ksあたりで呼び出せばよい
@call storage=SceneSkip.ks

始めはsf.sceneskipを0にしてシナリオ本編とフロウチャートを準備する
このときフロウチャートの各シーンには必ずセーブ可能ラベルをおき、
同じラベル名を使ってはならない
またシーンの終りには@rm をおく
出来たら scene.scene_saveに1を代入してその状態で各シーンを通れば、
ラベルの2文字目からの文字列のセーブファイルをothersフォルダにつくる

以後はシーンスキップが可能となる
