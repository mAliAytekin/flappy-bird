extends SceneTree
const Game = preload("res://scripts/game.gd")
const Save = preload("res://scripts/save_store.gd")
const Levels = preload("res://scripts/levels.gd")
var failures := 0
var checks := 0
var prefix := "user://faz3_"+str(Time.get_ticks_usec())
var cleanup: Array[String] = []
func check(ok: bool, text: String) -> void:
	checks += 1
	if ok: print("OK: ",text)
	else:
		failures += 1
		push_error(text)
func write_json(path: String, value: Variant) -> void:
	var file := FileAccess.open(path,FileAccess.WRITE)
	file.store_string(JSON.stringify(value))
	file.close()
	cleanup.append(path)
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var game = Game.new()
	root.add_child(game)
	game.set_physics_process(false)
	game.save=Save.new()
	game.save.path=prefix+"_save.json"
	cleanup.append(game.save.path)
	game.save.data.ses=false
	game.open_settings()
	var sliders: Array = []
	for child in game.panel.get_children():
		if child is HSlider: sliders.append(child)
	sliders[0].value=.2
	sliders[1].value=.9
	check(game.save.data.ayarlar.muzik==.2 and game.save.data.ayarlar.efekt==.9,"Müzik ve efekt kaydırıcıları ayrı ayarları değiştirir")
	game.close_settings()
	check(game.mode=="menu","Ayarlar kaydedilip menüye dönülür")
	var normal: Dictionary = {}
	for speed in [1.0,0.75,0.5]:
		game.save.data.ayarlar.hiz=speed
		game.start(4)
		game.begin()
		for frame in range(int(120/speed)):
			if game.bird_y+maxf(game.velocity,0)*.12>285 and game.velocity>-30: game.flap()
			game._physics_process(1.0/60)
		var state := {"x":game.distance,"y":game.bird_y,"v":game.velocity,"t":game.elapsed}
		if speed==1.0: normal=state
		else:
			check(absf(state.x-normal.x)<.001 and absf(state.y-normal.y)<.001 and absf(state.v-normal.v)<.001 and absf(state.t-normal.t)<.001,"Yardımcı hız %s aynı simülasyon sonucunu üretir" % speed)
			var obj := {"x":700,"y":170,"genlik":85,"periyot":4,"evre":0}
			check(game.FlightEnv.load_position(obj,state.t).is_equal_approx(game.FlightEnv.load_position(obj,normal.t)),"Yardımcı hız %s engelle aynı zamanı kullanır" % speed)
	check(game.rebind("ucus_tusu",KEY_F),"Uçuş tuşu yeniden atanabilir")
	check(not game.rebind("tekrar_tusu",KEY_F),"Çakışan tuş ataması reddedilir")
	check(not game.rebind("ucus_tusu",KEY_ESCAPE),"Esc güvenli çıkış olarak korunur")
	game.save.data.ayarlar.az_hareket=true
	game.save.data.ayarlar.muzik=.35
	game.save.data.ayarlar.efekt=.5
	game.save.write()
	var reload=Save.new()
	reload.path=game.save.path
	reload.read()
	check(reload.data.ayarlar.ucus_tusu==KEY_F and reload.data.ayarlar.az_hareket and reload.data.ayarlar.hiz==.5 and reload.data.ayarlar.muzik==.35,"Ayarlar diske yazılıp geri yüklenir")
	var legacy=prefix+"_v2.json"
	write_json(legacy,{"surum":2,"bakiye":14,"bolumler":{"LIMAN_01":{"tamam":true,"en_iyi":8}},"koleksiyon":["CATI_01"],"dekorlar":["kumas"],"secili_dekorlar":["kumas"],"ses":false})
	var migration=Save.new()
	migration.path=legacy
	migration.read()
	check(migration.data.surum==3 and migration.data.bakiye==14 and migration.data.koleksiyon==["CATI_01"] and migration.data.ayarlar.hiz==1.0,"Sürüm 2 kaydı yeni ayarlara kayıpsız geçer")
	migration.write()
	check(FileAccess.file_exists(legacy+".bak"),"Sürüm geçişi eski kaydı yedekler")
	write_json(legacy,{"surum":99,"bakiye":500})
	var future=Save.new()
	future.path=legacy
	future.read()
	check(not future.writable and not future.write() and FileAccess.get_file_as_string(legacy).contains("99"),"Daha yeni kayıt eski yedeğe dönülerek ezilmez")
	var broken=prefix+"_broken.json"
	var file:=FileAccess.open(broken,FileAccess.WRITE)
	file.store_string("invalid")
	file.close()
	cleanup.append(broken)
	var damaged=Save.new()
	damaged.path=broken
	damaged.read()
	check(not damaged.writable and FileAccess.get_file_as_string(broken)=="invalid","Yedeksiz bozuk kayıt korunur")
	var failing=Save.new()
	failing.path="user://olmayan_dizin_"+str(Time.get_ticks_usec())+"/save.json"
	check(not failing.deliver("CATI_01",5,true,"failed") and failing.data.bakiye==0 and not failing.completed("CATI_01"),"Disk yazımı başarısızsa teslim geri alınır")
	check(failing.data.son_oturum=="","Başarısız teslim yeniden denenebilir")
	var catalog: Array = Levels.read_json("res://data/level_catalog.json")
	var ninth: Dictionary = Levels.read_json(catalog[0].dosya).duplicate(true)
	ninth.kimlik="TEST_09"
	ninth.ad="Güncelleme denemesi"
	var ninth_path=prefix+"_ninth.json"
	var catalog_path=prefix+"_catalog.json"
	write_json(ninth_path,ninth)
	catalog.append({"dosya":ninth_path,"onceki":"LIMAN_04"})
	write_json(catalog_path,catalog)
	var extended:=Levels.load_levels(catalog_path)
	check(extended.errors.is_empty() and extended.levels.size()==9,"Dokuzuncu bölüm yalnızca veri ve katalogla yüklenir")
	game.levels=extended.levels
	game.save=Save.new()
	game.save.path=prefix+"_sequence.json"
	cleanup.append(game.save.path)
	game.save.data.ses=false
	# Yeni kayıtla sırayla sekiz bölüm; ganimet toplama açık.
	for index in range(8):
		var item: Dictionary = game.levels[index]
		check(item.onceki=="" or game.save.completed(item.onceki),"Temiz ilerleme: %s açılabilir" % item.kimlik)
		game.start(index)
		game.begin()
		fly(game)
		check(game.save.completed(item.kimlik),"Temiz ilerleme: %s tamamlandı" % item.kimlik)
	game.start(8)
	game.begin()
	fly(game)
	check(game.save.completed("TEST_09"),"Yeni bölüm çekirdek kod değişmeden oynanıp kaydedilir")
	game.set_page(2)
	check(game.menu_page==2,"Yeni bölümün menü sayfası erişilebilir")
	game.set_collection_page(1)
	check(game.collection_page==1,"Yeni bölümün koleksiyon sayfası erişilebilir")
	var invalid: Array = catalog.duplicate(true)
	invalid[8].onceki="YOK"
	write_json(catalog_path,invalid)
	check(not Levels.load_levels(catalog_path).errors.is_empty(),"Hatalı önkoşul anlaşılır hata verir")
	invalid[8].onceki="TEST_09"
	write_json(catalog_path,invalid)
	check(not Levels.load_levels(catalog_path).errors.is_empty(),"Döngüsel önkoşul reddedilir")
	invalid[8].dosya="res://data/levels/yok.json"
	write_json(catalog_path,invalid)
	check(not Levels.load_levels(catalog_path).errors.is_empty(),"Eksik bölüm dosyası oyunu çökertmez")
	invalid=catalog.duplicate(true)
	invalid[8].dosya=invalid[0].dosya
	write_json(catalog_path,invalid)
	check(not Levels.load_levels(catalog_path).errors.is_empty(),"Yinelenen bölüm kimliği reddedilir")
	game.queue_free()
	await process_frame
	for path in cleanup:
		for suffix in ["", ".bak", ".tmp"]:
			if FileAccess.file_exists(path+suffix): DirAccess.remove_absolute(path+suffix)
	print("SONUÇ: %d kontrol, %d hata" % [checks,failures])
	quit(1 if failures else 0)
func fly(game: Node) -> void:
	for frame in range(10000):
		if game.mode != "playing": break
		var target:=275.0
		var nearest:=INF
		var obstacle_x:=-1.0
		for obj in game.level.nesneler:
			if obj.tur=="baca" and obj.x>=game.distance-65 and obj.x-game.distance<nearest:
				nearest=obj.x-game.distance
				obstacle_x=obj.x
		if nearest<340:
			var low:=72.0
			var high:=494.0
			for obj in game.level.nesneler:
				if obj.tur!="baca" or obj.x!=obstacle_x: continue
				if obj.y-obj.h/2<=1: low=maxf(low,obj.y+obj.h/2)
				elif obj.y+obj.h/2>=509: high=minf(high,obj.y-obj.h/2)
				else: low=obj.y+obj.h/2
			target=(low+high)/2+22
		for obj in game.level.nesneler:
			if obj.tur=="sallanan_yuk" and absf(obj.x-game.distance)<300: target=330
		if game.bird_y+maxf(0,game.velocity)*.12>target and game.velocity>-30: game.flap()
		game._physics_process(1.0/60)
