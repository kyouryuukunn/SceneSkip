
;フローチャート管理

@iscript
//最初の一回だけ実行
if (sf.scene_init === void){
	sf.checkread = new Dictionary(); //一度でもシーンを見たかどうか
	sf.checklink = new Dictionary(); //一度でも選択したかどうか
	sf.scene_init = 1;
}
f.checklink = %[];
var scene = %[];
function scene_getcurlabel(){ 
	return kag.conductor.curLabel.indexOf('_') == -1 ? kag.conductor.curLabel.substring(1) : kag.conductor.curLabel.substring(1, kag.conductor.curLabel.indexOf('_')-1);
}
@endscript


@macro name=flow
@eval exp="mp.skipstorage = mp.skipstorage !== void ? mp.skipstorage : kag.conductor.curStorage"
@eval exp="mp.backstorage = mp.backstorage !== void ? mp.backstorage : kag.conductor.curStorage"
@eval exp="f.scene_skip_storage = mp.skipstorage"
@eval exp="f.scene_skip_target  = mp.skiptarget"
@if exp="sf.checkread[mp.target.substring(1)] != 0 && sf.sceneskip == 1 && !scene.scene_mode && !mp.disable"
	@call storage="scene.ks" target=*Question
	@if exp="mp.skipAnswer==1"
		@eval exp="f.scene_skip=1"
		@jump storage=%skipstorage target=%skiptarget
	@elsif exp="mp.skipAnswer==2"
		@eval exp="f.scene_skip=1"
		@jump storage=%backstorage target=%backtarget
	@elsif exp="mp.skipAnswer==0"
		@eval exp="f.scene_skip=0"
		;シーンロード
		@eval exp="scene.scene_load=1"
		@eval exp="scene.saveThumbnail = kag.saveThumbnail"
		@eval exp="kag.saveThumbnail = false"
		;ゲーム変数をバックアップ
		@eval exp="scene.temp_f = %[]"
		@eval exp="(Dictionary.assign incontextof scene.temp_f)(f)"
		@eval exp="scene.temp_f.history = []"
		@eval exp="scene.temp_f.history.assign(kag.historyOfStore)"
		@eval exp="scene.temp_f.historyData = kag.historyLayer.save()"
		@eval exp="kag.loadBookMarkFromFile(Storages.getPlacedPath(kag.conductor.curLabel.substring(1) + '.scene'), true)"
	@endif
@else
	;シーンスキップで来た場合
	@if exp="f.scene_skip"
		@eval exp="f.scene_skip=0"
		;シーンロード
		@eval exp="scene.scene_load=1"
		@eval exp="scene.saveThumbnail = kag.saveThumbnail"
		@eval exp="kag.saveThumbnail = false"
		;ゲーム変数をバックアップ
		@eval exp="scene.temp_f = %[]"
		@eval exp="(Dictionary.assign incontextof scene.temp_f)(f)"
		@eval exp="scene.temp_f.history = []"
		@eval exp="scene.temp_f.history.assign(kag.historyOfStore)"
		@eval exp="scene.temp_f.historyData = kag.historyLayer.save()"
		@eval exp="kag.loadBookMarkFromFile(Storages.getPlacedPath(kag.conductor.curLabel.substring(1) + '.scene'), true)"
	@else
		@eval exp="f.scene_storage=mp.storage, f.scene_target=mp.target"
		@jump storage=scene.ks target=*シーンセーブ用ラベル
	@endif
@endif
;何故か進んでしまうのでここで止める
@s
@endmacro


;回想モード用
@macro name=scene
@if exp="sf.checkread[mp.target] != 0"
	@locate x=%x y=%y
	@link storage=scene.ks target=*jump_scene exp="&'tf.read_storage=\'' + mp.read_storage + '\', tf.read_target=\'' + mp.read_target + '\', scene.scene_mode=1, tf.target=\'' + mp.target + '\''"
	@nowait
	@ch text=%target
	@endnowait
	@endlink
@endif
@endmacro

;回想モードに戻る
@macro name=rmm
@if exp="scene.scene_mode"
	@eval exp="scene.scene_mode=0"
	@jump storage=&scene.scene_mode_storage target=&scene.scene_mode_target
@endif
@endmacro

;フローチャートに戻る
@macro name=rm
@eval exp="sf.checkread[scene_getcurlabel()]=1"
@eval exp="mp.storage = f.scene_skip_storage if mp.storage === void"
@eval exp="mp.target  = f.scene_skip_target  if mp.target === void""
@jump storage=&f.scene_skip_storage target=&f.scene_skip_target
@endmacro


;選択済色替え,選択記録
;@lk target="" text=""
@macro name=lk
@eval exp="sf.checkread[scene_getcurlabel()]=1"
;バックで戻ってきたときのためにフラグ初期化
@eval exp="&'f.checklink[\'' + mp.text + '\']=0'"
@eval exp="mp.storage = kag.conductor.curStorage" cond="mp.storage === void"
@locate *
@link * exp="&'sf.checklink[\'' + mp.text + '\']=1, ' + 'f.checklink[\'' + mp.text + '\']=1'"
@nowait
@font color=0x666666 cond="sf.checklink[mp.text]==1"
@ch *
@resetfont cond="sf.checklink[mp.text]==1"
@endnowait
@endlink
@r
;@if exp="typeof(global.MoveMouseCursorPlugin_object) != 'undefined'"
;	@eval exp="MouseCursorMover.set(%[layer:kag.fore.messages[0], x:mp.x, y:mp.y, time:300, accel:-4])"
;@else
@eval exp="kag.current.setFocusToLink(0, true)"
	;@eval exp="kag.fore.base.cursorX=mp.x, kag.fore.base.cursorY=mp.y"
;@endif
@endmacro

@return

;サブルーチン
;シーンスキップ確認画面
*Question
@cm
@iscript
if(typeof(global.exsystembutton_object) != "undefined" && kag.fore.messages[0].visible)
	exsystembutton_object.onMessageHiddenStateChanged(true);
if(typeof(global.MoveMenu_object) != "undefined" && kag.fore.messages[0].visible)
	tf.move_menuon=0;
@endscript
@rclick enabled=false
@history output=false enabled=true
@nowait
@style align=center
[emb exp=mp.target.substring(1)][r]
@resetstyle
[r]
[emb exp=mp.outline][r]
@locate y=250
@style align=center
既読シーンです、スキップしますか？[r]
[link storage=scene.ks target=*Answer exp="mp.skipAnswer=1"]skip[endlink][r]
[link storage=scene.ks target=*Answer exp="mp.skipAnswer=0"]no[endlink][r]
[link storage=scene.ks target=*Answer exp="mp.skipAnswer=2"]back[endlink][r]
;@if exp="typeof(global.MoveMouseCursorPlugin_object) != 'undefined'"
;	@MoveCursor x="&(kag.scWidth/2)" y=360
;@else
@eval exp="kag.current.setFocusToLink(0, true)"
	;@eval exp="kag.fore.base.cursorX=(kag.scWidth/2), kag.fore.base.cursorY=360"
;@endif
@resetstyle
@endnowait
@s


*Answer
@history output=true enabled=true
@return

;全てのシーンはここを通る
*シーンセーブ用ラベル|
;スキップできたらなら変数のつじつまを合わせる
@if exp="scene.scene_load"
	@eval exp="(Dictionary.assign incontextof f.checklink)(scene.temp_f.checklink)"
	@eval exp="kag.historyOfStore.assign(scene.temp_f.history)"
	@eval exp="kag.historyLayer.load(scene.temp_f.historyData)"
	@eval exp="kag.saveThumbnail = scene.saveThumbnail"
	@eval exp="scene.scene_load=0"
@endif
;scene.scene_saveが真ならスキップ用にセーブを取る
;シナリオが完成したら使う
;以後シーンスキップと回想モードが使えるようになる
@if exp="scene.scene_save"
	@eval exp="scene.saveThumbnail = kag.saveThumbnail"
	@eval exp="kag.saveThumbnail = false"
	@eval exp="kag.saveBookMarkToFile(System.exePath + 'data/others/' + f.scene_target.substring(1) + '.scene', true)"
	@eval exp="kag.saveThumbnail = scene.saveThumbnail"
@endif
;タイミングの問題なのか下に空白が必要(1文字だけ先走る)
 
@jump storage=&f.scene_storage target=&f.scene_target

;回想モード用
*jump_scene
@call storage=&tf.read_storage target=&tf.read_target
;シーンロード
@eval exp="scene.scene_load=1"
@eval exp="scene.saveThumbnail = kag.saveThumbnail"
@eval exp="kag.saveThumbnail = false"
;ゲーム変数をバックアップ
@eval exp="scene.temp_f = %[]"
@eval exp="(Dictionary.assign incontextof scene.temp_f)(f)"
@eval exp="scene.temp_f.history = []"
@eval exp="scene.temp_f.history.assign(kag.historyOfStore)"
@eval exp="scene.temp_f.historyData = kag.historyLayer.save()"
@eval exp="kag.loadBookMarkFromFile(Storages.getPlacedPath(tf.target+'.scene'), true)"
