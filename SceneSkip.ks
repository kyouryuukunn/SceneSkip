
;�t���[�`���[�g�Ǘ�

@iscript
//�ŏ��̈�񂾂����s
if (sf.scene_init === void){
	sf.checkread = new Dictionary(); //��x�ł��V�[�����������ǂ���
	sf.checklink = new Dictionary(); //��x�ł��I���������ǂ���
	sf.scene_init = 1;
}
f.checklink = %[];
var scene = %[];
scene.getcurlabel = function (){ 
	return kag.conductor.curLabel.indexOf('_') == -1 ? kag.conductor.curLabel.substring(1) : kag.conductor.curLabel.substring(1, kag.conductor.curLabel.indexOf('_')-1);
} incontextof kag;
@endscript


@macro name=flow
@eval exp="mp.skipstorage = mp.skipstorage !== void ? mp.skipstorage : kag.conductor.curStorage"
@eval exp="mp.backstorage = mp.backstorage !== void ? mp.backstorage : kag.conductor.curStorage"
@eval exp="f.scene_skip_storage = mp.skipstorage"
@eval exp="f.scene_skip_target  = mp.skiptarget"
@if exp="sf.checkread[mp.target.substring(1)] != 0 && sf.sceneskip == 1 && !scene.scene_mode && !mp.disable"
	@call storage="SceneSkip.ks" target=*Question
	@if exp="mp.skipAnswer==1"
		@eval exp="f.scene_skip=1"
		@jump storage=%skipstorage target=%skiptarget
	@elsif exp="mp.skipAnswer==2"
		@eval exp="f.scene_skip=1"
		@jump storage=%backstorage target=%backtarget
	@elsif exp="mp.skipAnswer==0"
		@eval exp="f.scene_skip=0"
		;�V�[�����[�h
		@eval exp="scene.scene_load=1"
		@eval exp="scene.saveThumbnail = kag.saveThumbnail"
		@eval exp="kag.saveThumbnail = false"
		;�Q�[���ϐ����o�b�N�A�b�v
		@eval exp="scene.temp_f = %[]"
		@eval exp="(Dictionary.assign incontextof scene.temp_f)(f)"
		@eval exp="scene.temp_f.history = []"
		@eval exp="scene.temp_f.history.assign(kag.historyOfStore)"
		@eval exp="scene.temp_f.historyData = kag.historyLayer.save()"
		@eval exp="kag.loadBookMarkFromFile(Storages.getPlacedPath(kag.conductor.curLabel.substring(1) + '.scene'), true)"
	@endif
@else
	;�V�[���X�L�b�v�ŗ����ꍇ
	@if exp="f.scene_skip"
		@eval exp="f.scene_skip=0"
		;�V�[�����[�h
		@eval exp="scene.scene_load=1"
		@eval exp="scene.saveThumbnail = kag.saveThumbnail"
		@eval exp="kag.saveThumbnail = false"
		;�Q�[���ϐ����o�b�N�A�b�v
		@eval exp="scene.temp_f = %[]"
		@eval exp="(Dictionary.assign incontextof scene.temp_f)(f)"
		@eval exp="scene.temp_f.history = []"
		@eval exp="scene.temp_f.history.assign(kag.historyOfStore)"
		@eval exp="scene.temp_f.historyData = kag.historyLayer.save()"
		@eval exp="kag.loadBookMarkFromFile(Storages.getPlacedPath(kag.conductor.curLabel.substring(1) + '.scene'), true)"
	@else
		@eval exp="f.scene_storage=mp.storage, f.scene_target=mp.target"
		@jump storage=SceneSkip.ks target=*�V�[���Z�[�u�p���x��
	@endif
@endif
;���̂��i��ł��܂��̂ł����Ŏ~�߂�
@s
@endmacro


;��z���[�h�p
@macro name=scene
@if exp="sf.checkread[mp.target] != 0"
	@locate x=%x y=%y
	@link storage=SceneSkip.ks target=*jump_scene exp="&'scene.read_storage=\'' + mp.read_storage + '\', scene.read_target=\'' + mp.read_target + '\', scene.scene_mode=1, scene.target=\'' + mp.target + '\''"
	@nowait
	@ch text=%target
	@endnowait
	@endlink
@endif
@endmacro

;��z���[�h�ɖ߂�
@macro name=rmm
@if exp="scene.scene_mode"
	@eval exp="scene.scene_mode=0"
	@jump storage=&scene.scene_mode_storage target=&scene.scene_mode_target
@endif
@endmacro
;��z��ɖ߂�ꏊ��ݒ�
@macro name=scene_back
@eval exp="scene.scene_mode_storage=mp.storage"
@eval exp="scene.scene_mode_target=mp.target"
@endmacro

;�t���[�`���[�g�ɖ߂�
@macro name=rm
@eval exp="sf.checkread[scene.getcurlabel()]=1"
@eval exp="mp.storage = f.scene_skip_storage if mp.storage === void"
@eval exp="mp.target  = f.scene_skip_target  if mp.target === void""
@jump storage=&f.scene_skip_storage target=&f.scene_skip_target
@endmacro


;�I���ϐF�ւ�,�I���L�^
;@lk target="" text=""
@macro name=lk
@eval exp="sf.checkread[scene.getcurlabel()]=1"
;�o�b�N�Ŗ߂��Ă����Ƃ��̂��߂Ƀt���O������
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
@if exp="typeof(global.MoveMouseCursorPlugin_object) != 'undefined'"
	@eval exp="MouseCursorMover.set(%[layer:kag.fore.messages[0], x:(int)mp.x + kag.fore.messages[kag.current.name[9]].marginL + kag.fore.messages[kag.current.name[9]].left + 10, y:(int)mp.y + kag.fore.messages[kag.current.name[9]].marginT + kag.fore.messages[kag.current.name[9]].top + 10, time:300, accel:-4])"
@else
	@eval exp="kag.fore.base.cursorX = (int)mp.x + kag.fore.messages[kag.current.name[9]].marginL + kag.fore.messages[kag.current.name[9]].left + 10, kag.fore.base.cursorY = (int)mp.y + kag.fore.messages[kag.current.name[9]].marginT + kag.fore.messages[kag.current.name[9]].top + 10"
@endif
@endmacro

@return

;�T�u���[�`��--------------------------------------------------------------- 
;�V�[���X�L�b�v�m�F���
*Question
@cm
@iscript
//�Z�[�u���[�h���֎~����
if(typeof(global.exsystembutton_object) != "undefined" && kag.fore.messages[0].visible)
	exsystembutton_object.onMessageHiddenStateChanged(true);
if(typeof(global.MoveMenu_object) != "undefined" && kag.fore.messages[0].visible)
	MoveMenu_object.move_menuon=0;
scene.current_message_back = kag.current.name[9];
@endscript
;��ʂ��Ó]���Ď���
@laycount messages="&kag.numMessageLayers + 1"
@current layer="&'message' + (kag.numMessageLayers-1)"
@position layer=message left=0 top=0 width=&kag.scWidth height=&kag.scHeight opacity=255 visible=true
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
���ǃV�[���ł��A�X�L�b�v���܂����H[r]
[link storage=SceneSkip.ks target=*Answer exp="mp.skipAnswer=1"]skip[endlink][r]
[link storage=SceneSkip.ks target=*Answer exp="mp.skipAnswer=0"]no[endlink][r]
[link storage=SceneSkip.ks target=*Answer exp="mp.skipAnswer=2"]back[endlink][r]
@if exp="typeof(global.MoveMouseCursorPlugin_object) != 'undefined'"
	@eval exp="MouseCursorMover.set(%[layer:kag.fore.messages[0], x:kag.scWidth/2, y:250 + kag.fore.messages[kag.current.name[9]].marginT + 50, time:300, accel:-4])"
@else
	@eval exp="kag.fore.base.cursorX = kag.scWidth/2, kag.fore.base.cursorY = 250 + kag.fore.messages[kag.current.name[9]].marginT + 50"
@endif
@resetstyle
@endnowait
@s


*Answer
;���̏�Ԃ̂܂ܐi�ނ̂�end�������낤����
;�߂��K�v�͂Ȃ��Ǝv��
;���b�Z�[�W���C����߂�
@current layer="&'message' + scene.current_message_back"
@laycount messages="&kag.numMessageLayers - 1"
@endif
@return

;�S�ẴV�[���͂�����ʂ�--------------------------------------------------- 
*�V�[���Z�[�u�p���x��|
;�X�L�b�v�ł�����Ȃ�ϐ��̂��܂����킹��
@if exp="scene.scene_load"
	@eval exp="(Dictionary.assign incontextof f.checklink)(scene.temp_f.checklink)"
	@eval exp="kag.historyOfStore.assign(scene.temp_f.history)"
	@eval exp="kag.historyLayer.load(scene.temp_f.historyData)"
	@eval exp="kag.saveThumbnail = scene.saveThumbnail"
	@eval exp="scene.scene_load=0"
@endif
;scene.scene_save���^�Ȃ�X�L�b�v�p�ɃZ�[�u�����
;�V�i���I������������g��
;�Ȍ�V�[���X�L�b�v�Ɖ�z���[�h���g����悤�ɂȂ�
@if exp="scene.scene_save"
	;�]���ȃf�[�^����菜��
	@eval exp="scene.storeState = kag.historyLayer.storeState"
	@eval exp="kag.historyLayer.storeState = false"
	@eval exp="scene.maxHistoryOfStore = kag.maxHistoryOfStore"
	@eval exp="kag.maxHistoryOfStore = 0"
	@eval exp="scene.saveDataMode = kag.saveDataMode"
	@eval exp="kag.saveDataMode = 'z'"
	@eval exp="scene.saveThumbnail = kag.saveThumbnail"
	@eval exp="kag.saveThumbnail = false"
	@eval exp="kag.saveBookMarkToFile(System.exePath + 'data/others/' + f.scene_target.substring(1) + '.scene', true)"
	;�o�b�N�A�b�v����߂�
	@eval exp="kag.historyLayer.storeState = scene.storeState"
	@eval exp="kag.saveThumbnail = scene.saveThumbnail"
	@eval exp="kag.saveDataMode = scene.saveDataMode"
	@eval exp="kag.maxHistoryOfStore = scene.maxHistoryOfStore"
@endif
;�^�C�~���O�̖��Ȃ̂����ɋ󔒂��K�v(1���������摖��)
 
@jump storage=&f.scene_storage target=&f.scene_target

;��z���[�h�p--------------------------------------------------------------- 
*jump_scene
@call storage=&scene.read_storage target=&scene.read_target
;�V�[�����[�h
@eval exp="scene.scene_load=1"
@eval exp="scene.saveThumbnail = kag.saveThumbnail"
@eval exp="kag.saveThumbnail = false"
;�Q�[���ϐ����o�b�N�A�b�v
@eval exp="scene.temp_f = %[]"
@eval exp="(Dictionary.assign incontextof scene.temp_f)(f)"
@eval exp="scene.temp_f.history = []"
@eval exp="scene.temp_f.history.assign(kag.historyOfStore)"
@eval exp="scene.temp_f.historyData = kag.historyLayer.save()"
@eval exp="kag.loadBookMarkFromFile(Storages.getPlacedPath(scene.target+'.scene'), true)"
