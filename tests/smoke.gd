extends SceneTree
const Game = preload("res://scripts/game.gd")
const Levels = preload("res://scripts/levels.gd")
const Save = preload("res://scripts/save_store.gd")
var failures := 0

func check(condition: bool, description: String) -> void:
	if condition: print("OK: ", description)
	else:
		push_error(description)
		failures += 1

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var catalog := Levels.load_levels()
	check(catalog.errors.is_empty() and catalog.levels.size() == 8, "Sekiz bölüm verisi geçerli")
	var bad: Dictionary = catalog.levels[0].duplicate(true)
	bad.nesneler.append(bad.nesneler[0].duplicate())
	check(not Levels.validate(bad).is_empty(), "Yinelenen nesne reddedildi")
	bad = catalog.levels[0].duplicate(true)
	bad.nesneler[0].tur = "bilinmeyen"
	check(not Levels.validate(bad).is_empty(), "Bilinmeyen nesne reddedildi")
	var store = Save.new()
	store.path = "user://test_save_" + str(Time.get_ticks_usec()) + ".json"
	check(store.deliver("CATI_01", 4, false, "a"), "Ara teslim işlendi")
	check(not store.completed("CATI_01"), "Ara teslim bölüm açmaz")
	check(not store.deliver("CATI_01", 4, false, "a") and store.data.bakiye == 4, "Aynı teslim iki kez işlenmez")
	store.deliver("CATI_01", 3, true, "b")
	var reload = Save.new()
	reload.path = store.path
	reload.read()
	check(reload.completed("CATI_01") and reload.data.bakiye == 7, "İlerleme diskten geri yüklendi")
	var game = Game.new()
	root.add_child(game)
	game.set_physics_process(false)
	game.save = store
	game.save.data.ses = false
	for index in range(8):
		for load_amount in range(7):
			game.start(index)
			game.begin()
			game.weight = load_amount
			# Ganimet alımını devre dışı bırakarak iki fizik uç durumunu ayrı doğrula.
			for obj in game.level.nesneler:
				if obj.tur == "ganimet": game.collected[obj.kimlik] = true
			for frame in range(10000):
				if game.mode != "playing": break
				var target := 275.0
				var nearest := INF
				var obstacle_x := -1.0
				for obj in game.level.nesneler:
					if obj.tur == "baca" and obj.x >= game.distance - 65 and obj.x - game.distance < nearest:
						nearest = obj.x - game.distance
						obstacle_x = obj.x
				if nearest < 340:
					var low := 72.0
					var high := 494.0
					for obj in game.level.nesneler:
						if obj.tur != "baca" or obj.x != obstacle_x: continue
						if obj.y - obj.h/2 <= 1: low = maxf(low, obj.y+obj.h/2)
						elif obj.y + obj.h/2 >= 509: high = minf(high, obj.y-obj.h/2)
						else: low = obj.y+obj.h/2
					target = (low+high)/2+22
				for obj in game.level.nesneler:
					if obj.tur == "sallanan_yuk" and absf(obj.x-game.distance)<300:
						target = 330.0
				if game.bird_y + maxf(0, game.velocity)*0.12 > target and game.velocity > -30:
					game.flap()
				game._physics_process(1.0/60)
			check(game.mode == "result" and game.result_body.contains("Bölüm tamamlandı"), "%s yük=%d son yuvaya erişim (x=%.0f)" % [game.level.kimlik,load_amount,game.distance])
	game.start(1)
	game.begin()
	game.value = 5
	for obj in game.level.nesneler:
		if obj.tur == "yuva" and not obj.son:
			game.distance = obj.x
			game.bird_y = obj.y
			break
	game.interactions()
	check(game.result_body.contains("Erken teslim"), "Gerçek oyun akışında ara yuva")
	game.start(0)
	game.begin()
	var before: int = store.data.bakiye
	game.value = 6
	game.bird_y = 500
	game._physics_process(1.0/60)
	check(game.mode == "result" and store.data.bakiye == before, "Çarpışma eski bakiyeyi korur")
	game.start(0)
	game.begin()
	game.pause_game()
	var previous: float = game.distance
	game._physics_process(1.0)
	check(game.distance == previous, "Duraklatma fiziği durdurur")
	game.resume()
	check(game.mode == "playing", "Duraklatmadan dönüş")
	game.start(0)
	check(game.weight == 0 and game.value == 0 and game.collected.is_empty(), "Yeniden başlatma oturumu temizler")
	game.begin()
	var pickup: Dictionary = {}
	for obj in game.level.nesneler:
		if obj.tur == "ganimet":
			pickup = obj
			break
	game.distance = pickup.x
	game.bird_y = pickup.y
	game.interactions()
	check(game.weight == 1 and game.value == 1, "Kapak toplama ağırlık ve değer ekler")
	game.interactions()
	check(game.weight == 1 and game.value == 1, "Aynı eşya tekrar toplanmaz")
	game.collected.clear()
	game.weight = 6
	game.interactions()
	check(game.weight == 6 and game.value == 1, "Kapasite üstündeki eşya alınmaz")
	# Faz 1 kaydı yeni alanlar olmadan da yüklenir; başarı ve bakiye korunur.
	var old_path: String = store.path + ".legacy"
	var old_file := FileAccess.open(old_path,FileAccess.WRITE)
	old_file.store_string(JSON.stringify({"surum":1,"bakiye":17,"bolumler":{"CATI_04":{"tamam":true,"en_iyi":8}},"ses":false,"son_oturum":"eski"}))
	old_file.close()
	var migrated = Save.new()
	migrated.path = old_path
	migrated.read()
	check(migrated.data.surum==3 and migrated.data.bakiye==17 and migrated.completed("CATI_04") and migrated.data.koleksiyon.is_empty(), "Faz 1 kaydı kayıpsız sürüm 3'e geçti")
	check(migrated.completed(catalog.levels[4].onceki), "Eski CATI_04 başarısı Liman'ı açar")
	check(migrated.purchase("kumas") and migrated.data.bakiye==14, "Dekor satın alma bedeli bir kez düşülür")
	check(not migrated.purchase("kumas") and migrated.data.bakiye==14, "Aynı dekor ikinci kez satın alınamaz")
	migrated.toggle_decor("kumas")
	check(not "kumas" in migrated.data.secili_dekorlar and "kumas" in migrated.data.dekorlar, "Dekor kaldırmak sahipliği korur")
	migrated.data.bakiye=0
	check(not migrated.purchase("lamba"), "Yetersiz bakiye satın almaya izin vermez")
	migrated.deliver("LIMAN_01",0,false,"hatira1",true)
	migrated.deliver("LIMAN_01",0,false,"hatira2",true)
	check(migrated.data.koleksiyon.size()==1 and not migrated.completed("LIMAN_01"), "Hatıra teslimi tekilleşir ve bölüm açmaz")
	var phase2_reload = Save.new()
	phase2_reload.path=old_path
	phase2_reload.read()
	check("LIMAN_01" in phase2_reload.data.koleksiyon and "kumas" in phase2_reload.data.dekorlar, "Koleksiyon ve dekor diskten geri yüklendi")
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(old_path+suffix): DirAccess.remove_absolute(old_path+suffix)
	var wind_zone := {"tur":"ruzgar","x":500,"y":270,"w":300,"h":300,"kuvvet":-200}
	check(game.FlightEnv.wind_at([wind_zone],Vector2(500,270))==-200 and game.FlightEnv.wind_at([wind_zone],Vector2(50,270))==0, "Rüzgâr yalnızca alanının içinde etkili")
	var moving := {"tur":"sallanan_yuk","x":700,"y":170,"w":64,"h":64,"genlik":85,"periyot":4.0,"evre":0.0}
	check(game.FlightEnv.load_position(moving,0).is_equal_approx(game.FlightEnv.load_position(moving,4)), "Salınım sabit periyotta aynı konuma döner")
	game.start(5)
	game.begin()
	game.elapsed=1.0
	game.pause_game()
	game._physics_process(2.0)
	check(game.elapsed==1.0, "Duraklatma hareketli engel zamanını dondurur")
	game.start(5)
	check(game.elapsed==0.0, "Yeniden deneme salınım evresini sıfırlar")
	game.begin()
	for obj in game.level.nesneler:
		if obj.tur=="sallanan_yuk":
			var pos: Vector2 = game.FlightEnv.load_position(obj,game.elapsed)
			game.distance=pos.x
			game.bird_y=pos.y
			break
	game.interactions()
	check(game.mode=="result", "Sallanan yükün gerçek konumunda çarpışma oluşur")
	game.save.data.koleksiyon.clear()
	game.start(0)
	game.begin()
	for obj in game.level.nesneler:
		if obj.tur=="ozel_esya":
			game.distance=obj.x
			game.bird_y=obj.y
	game.interactions()
	check(game.carrying_special and game.save.data.koleksiyon.is_empty(), "Hatıra almak henüz kalıcı kazanım değildir")
	game.finish(false,false)
	check(game.save.data.koleksiyon.is_empty(), "Çarpışmada taşınan hatıra kazanılmaz")
	game.start(0)
	game.begin()
	game.carrying_special=true
	game.finish(true,true)
	check("CATI_01" in game.save.data.koleksiyon, "Yuva teslimi hatırayı kalıcı kaydeder")
	bad = catalog.levels[5].duplicate(true)
	for obj in bad.nesneler:
		if obj.tur=="sallanan_yuk": obj.periyot=0
	check(not Levels.validate(bad).is_empty(), "Sıfır salınım periyodu reddedilir")
	bad = catalog.levels[4].duplicate(true)
	for obj in bad.nesneler:
		if obj.tur=="ruzgar": obj.kuvvet=999
	check(not Levels.validate(bad).is_empty(), "Aşırı rüzgâr verisi reddedilir")
	game.start(4)
	game.begin()
	game.distance=737
	game.bird_y=275
	game.velocity=0
	game._physics_process(1.0/60)
	check(game.velocity < 850.0/60, "Yukarı rüzgâr oyun fiziğinde düşüşü azaltır")
	game.start(0)
	game.begin()
	game.weight=3
	game.flap()
	var plain: float = game.velocity
	game.save.data.secili_dekorlar=["kumas","sus","lamba","cani"]
	game.flap()
	check(game.velocity==plain, "Dekorlar kanat gücünü değiştirmez")
	var broken := FileAccess.open(store.path, FileAccess.WRITE)
	broken.store_string("bozuk kayıt")
	broken.close()
	var recovered = Save.new()
	recovered.path = store.path
	recovered.read()
	check(recovered.writable and recovered.warning.contains("yedekten"), "Bozuk kayıt yedekten kurtarıldı")
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(store.path+suffix): DirAccess.remove_absolute(store.path+suffix)
	print("SONUÇ: ", failures, " hata")
	game.queue_free()
	await process_frame
	quit(1 if failures else 0)
