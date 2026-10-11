extends Node2D
const FlightEnv = preload("res://scripts/environment.gd")
const Levels = preload("res://scripts/levels.gd")
const Save = preload("res://scripts/save_store.gd")
var save = Save.new()
var levels: Array = []
var errors: Array = []
var level: Dictionary = {}
var current := 0
var mode := "menu"
var distance := 160.0
var bird_y := 260.0
var velocity := 0.0
var weight := 0
var value := 0
var elapsed := 0.0
var collected := {}
var token := ""
var flash := 0.0
var message := ""
var result_title := ""
var result_body := ""
var ui: CanvasLayer
var panel: Control
var audio: AudioStreamPlayer
var particles: Array = []
var font = ThemeDB.fallback_font
const CROW = [preload("res://assets/art/crow_0.png"), preload("res://assets/art/crow_1.png"), preload("res://assets/art/crow_2.png"), preload("res://assets/art/crow_3.png")]
const ROOFTOPS = preload("res://assets/art/rooftops.png")
const CAP = preload("res://assets/art/cap.png")
const SPOON = preload("res://assets/art/spoon.png")
const CHIMNEY = preload("res://assets/art/chimney.png")
const CHIMNEY_CAP = preload("res://assets/art/chimney_cap.png")
const NEST = preload("res://assets/art/nest.png")
const NEST_FINAL = preload("res://assets/art/nest_final.png")
const SPECIAL_ART = {"dugme": preload("res://assets/art/special_dugme.png"), "yuzuk": preload("res://assets/art/special_yuzuk.png"), "boncuk": preload("res://assets/art/special_boncuk.png"), "saat": preload("res://assets/art/special_saat.png"), "kabuk": preload("res://assets/art/special_kabuk.png"), "pusula": preload("res://assets/art/special_pusula.png"), "tas": preload("res://assets/art/special_tas.png"), "madalya": preload("res://assets/art/special_madalya.png")}
var flap_time := 0.0
var simulation_accumulator := 0.0
var binding_field := ""
var settings_return := "menu"
var settings_notice := ""
var collection_page := 0
var menu_page := 0
var carrying_special := false
var music: AudioStreamPlayer
const HARBOR = preload("res://assets/art/harbor.png")
const CRATE = preload("res://assets/art/crate.png")
const MEDAL = preload("res://assets/art/medal.png")
const DECOR_ART = {"kumas": preload("res://assets/art/cloth.png"), "sus": preload("res://assets/art/ornament.png"), "lamba": preload("res://assets/art/lantern.png"), "cani": preload("res://assets/art/chime.png")}
const MUSIC_ROOF = preload("res://assets/audio/rooftops.wav")
const MUSIC_HARBOR = preload("res://assets/audio/harbor.wav")

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	save.read()
	var catalog: Dictionary = Levels.load_levels()
	levels = catalog.levels
	errors = catalog.errors
	ui = CanvasLayer.new()
	add_child(ui)
	audio = AudioStreamPlayer.new()
	add_child(audio)
	music = AudioStreamPlayer.new()
	music.volume_db = -22
	add_child(music)
	music.finished.connect(func():
		if save.data.ses: music.play())
	get_window().focus_exited.connect(func():
		if mode == "playing": pause_game())
	show_menu()

func clear_ui() -> void:
	if is_instance_valid(panel):
		ui.remove_child(panel)
		panel.queue_free()
	panel = Control.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(panel)

func label_at(text: String, pos: Vector2, size: int = 20, color: Color = Color("fff1d2")) -> Label:
	var item := Label.new()
	item.text = text
	item.position = pos
	item.add_theme_font_size_override("font_size", size)
	item.add_theme_color_override("font_color", color)
	panel.add_child(item)
	return item

func button_at(text: String, rect: Rect2, action: Callable, disabled: bool = false) -> void:
	var b := Button.new()
	b.text = text
	b.position = rect.position
	b.size = rect.size
	b.disabled = disabled
	b.add_theme_font_size_override("font_size", 19)
	for state in ["normal", "hover", "pressed", "disabled"]:
		var style := StyleBoxFlat.new()
		style.bg_color = Color("2d3949") if state == "normal" else Color("455566")
		if state == "disabled": style.bg_color = Color("343638")
		style.border_color = Color("e8b56b")
		style.set_border_width_all(1)
		style.set_corner_radius_all(10)
		b.add_theme_stylebox_override(state, style)
	b.pressed.connect(action)
	panel.add_child(b)

func set_page(page: int) -> void:
	menu_page = clampi(page,0,maxi(0,ceili(levels.size()/4.0)-1))
	show_menu()

func play_music(harbor: bool) -> void:
	apply_audio_settings()
	var stream: AudioStream = MUSIC_HARBOR if harbor else MUSIC_ROOF
	if music.stream != stream:
		music.stream = stream
		music.stop()
	music.stream_paused = false
	if save.data.ses and not music.playing: music.play()
	if not save.data.ses: music.stop()

func show_menu() -> void:
	mode = "menu"
	clear_ui()
	play_music(menu_page == 1)
	label_at(("RÜZGÂRLI LİMAN" if menu_page == 1 else "ÇATI MAHALLESİ") if menu_page < 2 else "YENİ ROTALAR  /  %d" % (menu_page+1), Vector2(65, 32), 16, Color("e9b96f"))
	label_at("Parlak İşler", Vector2(60, 53), 46)
	label_at("Bitiş  /  Ganimet hedefi  /  Özel eşya", Vector2(65, 113), 16)
	label_at("Yuva birikimi: %d ◇" % save.data.bakiye, Vector2(655, 42), 20)
	button_at("Çatılar", Rect2(490, 98, 125, 36), set_page.bind(0))
	button_at("Liman", Rect2(630, 98, 125, 36), set_page.bind(1))
	if levels.size()>8:
		button_at("←",Rect2(770,98,50,36),set_page.bind(menu_page-1),menu_page==0)
		button_at("→",Rect2(835,98,50,36),set_page.bind(menu_page+1),(menu_page+1)*4>=levels.size())
	for i in range(menu_page*4, mini(menu_page*4+4,levels.size())):
		var item: Dictionary = levels[i]
		var unlocked: bool = item.onceki == "" or save.completed(item.onceki)
		var x := 65.0 + (i % 2) * 435
		var y := 166.0 + floori((i % 4) / 2.0) * 113
		button_at("%02d   %s" % [i + 1, item.ad], Rect2(x, y, 395, 54), start.bind(i), not unlocked)
		var record: Dictionary = save.data.bolumler.get(item.kimlik,{})
		var marks := "%s Bitiş   %s %d◇   %s Hatıra" % ["✓" if save.completed(item.kimlik) else "○", "✓" if record.get("en_iyi",0)>=item.deger_hedefi else "○",item.deger_hedefi,"✓" if item.kimlik in save.data.koleksiyon else "○"]
		label_at(marks, Vector2(x+8,y+59),16,Color("e9b96f"))
		if not unlocked: label_at("Önce önceki bölümün son yuvasına ulaş.",Vector2(x+8,y+82),12)
	button_at("Ayarlar", Rect2(65, 429, 150, 40), open_settings)
	button_at("Yuvam / Koleksiyon", Rect2(235,429,245,40),show_home)
	label_at(flight_key_name()+" / TIKLA: Uç  •  ESC: Duraklat",Vector2(505,442),15)
	if not save.warning.is_empty(): label_at(save.warning, Vector2(65, 487), 13)
	if not errors.is_empty(): label_at(str(errors), Vector2(65, 487), 12, Color.SALMON)
	queue_redraw()

func show_home() -> void:
	mode = "home"
	clear_ui()
	play_music(false)
	label_at("Yuvam",Vector2(60,35),36)
	label_at("Birikim: %d ◇  •  Dekorlar yalnızca görünümü değiştirir." % save.data.bakiye,Vector2(60,86),16)
	label_at("Şehir turu bitti. Burası artık senin hikâyen." if save.completed("LIMAN_04") else "Her teslim, burayı biraz daha senin yapar.",Vector2(60,119),17)
	var row := 0
	for id in Save.DECOR:
		var entry: Dictionary = Save.DECOR[id]
		var owned: bool = id in save.data.dekorlar
		var selected: bool = id in save.data.secili_dekorlar
		var caption: String = entry.ad + ("  •  Kaldır" if selected else ("  •  Yerleştir" if owned else "  •  %d ◇" % entry.fiyat))
		button_at(caption,Rect2(530,158+row*55,365,43),decorate.bind(id),not owned and save.data.bakiye<entry.fiyat)
		row += 1
	label_at("KOLEKSİYON  %d / %d" % [save.data.koleksiyon.size(),levels.size()],Vector2(60,361),16,Color("e9b96f"))
	for i in range(collection_page*8, mini(collection_page*8+8, levels.size())):
		var item: Dictionary = levels[i]
		label_at(("✓ " if item.kimlik in save.data.koleksiyon else "○ ")+item.get("ozel_esya_adi",item.ad),Vector2(86+(i%4)*212,396+floori((i%8)/4.0)*27),15)
	button_at("← Bölümler",Rect2(60,466,200,39),show_menu)
	if levels.size()>8:
		button_at("←",Rect2(730,466,60,36),set_collection_page.bind(collection_page-1),collection_page==0)
		button_at("→",Rect2(805,466,60,36),set_collection_page.bind(collection_page+1),(collection_page+1)*8>=levels.size())
	if not save.warning.is_empty(): label_at(save.warning,Vector2(275,477),13)
	queue_redraw()

func set_collection_page(page: int) -> void:
	collection_page = clampi(page,0,maxi(0,ceili(levels.size()/8.0)-1))
	show_home()

func decorate(id: String) -> void:
	if id in save.data.dekorlar: save.toggle_decor(id)
	else: save.purchase(id)
	show_home()

func toggle_sound() -> void:
	save.data.ses = not save.data.ses
	save.write()
	show_menu()

func start(index: int) -> void:
	current = index
	menu_page = index / 4
	carrying_special = false
	play_music(levels[index].get("bolge", "cati") == "liman")
	level = levels[index]
	distance = 160
	bird_y = 265
	velocity = 0
	weight = 0
	value = 0
	elapsed = 0
	simulation_accumulator = 0
	collected.clear()
	particles.clear()
	message = ""
	token = str(Time.get_unix_time_from_system()) + "-" + str(Time.get_ticks_usec())
	mode = "ready"
	clear_ui()
	label_at(level.ad, Vector2(55, 130), 36)
	var tip := label_at(level.ipucu, Vector2(55, 186), 18)
	tip.size.x = 850
	tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button_at("Kanatları aç  •  " + flight_key_name(), Rect2(55, 235, 330, 54), begin)
	label_at("Ara yuva: kazancı korur. Son yuva: bölümü tamamlar.", Vector2(55, 311), 17)
	label_at("İsteğe bağlı: %d◇ teslim et • %s bul ve teslim et" % [level.deger_hedefi, level.get("ozel_esya_adi", "Hatıra")],Vector2(55,352),17)
	queue_redraw()

func begin() -> void:
	mode = "playing"
	clear_ui()
	button_at("Ⅱ", Rect2(887, 15, 48, 36), pause_game)
	flap()

func flap() -> void:
	flap_time = 0.0
	velocity = -300.0 * (1.0 - 0.10 * weight / 6.0)
	flash = 0.13

func flight_key_name() -> String:
	return "BOŞLUK" if int(save.data.ayarlar.ucus_tusu) == KEY_SPACE else OS.get_keycode_string(int(save.data.ayarlar.ucus_tusu))

func _input(event: InputEvent) -> void:
	if mode == "settings" and not binding_field.is_empty() and event is InputEventKey and event.pressed and not event.echo:
		get_viewport().set_input_as_handled()
		if event.keycode == KEY_ESCAPE:
			binding_field = ""
			show_settings()
			return
		if event.ctrl_pressed or event.alt_pressed or event.meta_pressed or event.keycode in [KEY_SHIFT,KEY_CTRL,KEY_ALT,KEY_META]: return
		if rebind(binding_field,event.keycode): binding_field = ""
		show_settings()
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE or event.keycode == int(save.data.ayarlar.duraklat_tusu):
			if mode == "playing": pause_game()
			elif mode == "paused": resume()
			elif mode == "settings": close_settings()
			elif mode != "menu": show_menu()
			get_viewport().set_input_as_handled()
			return
		if mode == "playing" and event.keycode == int(save.data.ayarlar.ucus_tusu):
			flap()
			get_viewport().set_input_as_handled()
		elif mode == "result" and event.keycode == int(save.data.ayarlar.tekrar_tusu):
			start(current)
			get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	var press: bool = (event is InputEventKey and event.pressed and not event.echo and event.keycode == int(save.data.ayarlar.ucus_tusu)) or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT)
	if press:
		if mode == "playing": flap()
		elif mode == "ready": begin()
		elif mode == "result": start(current)

func rebind(field: String, key: int) -> bool:
	if not field in ["ucus_tusu","duraklat_tusu","tekrar_tusu"] or key == KEY_ESCAPE or key == 0: return false
	for other in ["ucus_tusu","duraklat_tusu","tekrar_tusu"]:
		if other != field and int(save.data.ayarlar[other]) == key:
			settings_notice = "Bu tuş başka bir eylemde kullanılıyor. Başka bir tuş seç."
			return false
	save.data.ayarlar[field] = key
	settings_notice = "Tuş değiştirildi."
	return true

func apply_audio_settings() -> void:
	if is_instance_valid(music): music.volume_db = linear_to_db(maxf(0.0001,save.data.ayarlar.muzik))-15
	if is_instance_valid(audio): audio.volume_db = linear_to_db(maxf(0.0001,save.data.ayarlar.efekt))

func open_settings() -> void:
	settings_return = "paused" if mode == "paused" else "menu"
	settings_notice = ""
	binding_field = ""
	show_settings()

func show_settings() -> void:
	mode = "settings"
	clear_ui()
	label_at("Ayarlar",Vector2(65,36),36)
	var fields := ["ucus_tusu","duraklat_tusu","tekrar_tusu"]
	var titles := ["Kanat çırp", "Duraklat", "Tekrar dene"]
	for i in range(3):
		var field: String = fields[i]
		label_at(titles[i],Vector2(65,111+i*52),18)
		button_at("Bir tuşa bas…" if binding_field == field else ("Boşluk" if int(save.data.ayarlar[field])==KEY_SPACE else OS.get_keycode_string(int(save.data.ayarlar[field]))),Rect2(238,102+i*52,200,40),listen_key.bind(field))
	label_at("Esc her zaman duraklatır; atama sırasında iptal eder.",Vector2(65,264),15)
	label_at("Uçuş hızı",Vector2(505,108),18)
	var speed := OptionButton.new()
	speed.position=Vector2(665,102)
	speed.size=Vector2(205,40)
	for caption in ["Normal  %100","Yardımcı  %75","Yardımcı  %50"]: speed.add_item(caption)
	var speeds := [1.0,0.75,0.5]
	speed.select(speeds.find(float(save.data.ayarlar.hiz)))
	speed.item_selected.connect(func(index): save.data.ayarlar.hiz=speeds[index])
	panel.add_child(speed)
	var reduced := CheckButton.new()
	reduced.text="Azaltılmış hareket"
	reduced.position=Vector2(505,157)
	reduced.button_pressed=save.data.ayarlar.az_hareket
	reduced.toggled.connect(func(enabled): save.data.ayarlar.az_hareket=enabled)
	panel.add_child(reduced)
	label_at("Arka plan sabitlenir, parçacıklar kapanır.
Rüzgâr yön okları görünür kalır.",Vector2(505,204),15)
	for i in range(2):
		var field: String = "muzik" if i==0 else "efekt"
		label_at("Müzik" if i==0 else "Efektler",Vector2(65,316+i*48),18)
		var slider := HSlider.new()
		slider.position=Vector2(180,322+i*48)
		slider.size=Vector2(250,24)
		slider.min_value=0
		slider.max_value=1
		slider.step=0.05
		slider.value=save.data.ayarlar[field]
		slider.value_changed.connect(func(amount):
			save.data.ayarlar[field]=amount
			apply_audio_settings())
		panel.add_child(slider)
	button_at("Ses: " + ("Açık" if save.data.ses else "Kapalı"),Rect2(505,316,365,40),settings_mute)
	label_at("Yardımcı hız ödülleri azaltmaz.
Ekran sarsıntısı bu oyunda kullanılmıyor.",Vector2(505,371),15)
	button_at("Kaydet ve dön",Rect2(65,447,230,43),close_settings)
	label_at(settings_notice,Vector2(320,435),13,Color("e9b96f"))
	if not save.warning.is_empty(): button_at("Kaydetmeden dön",Rect2(570,465,270,33),leave_settings)
	queue_redraw()

func listen_key(field: String) -> void:
	binding_field=field
	settings_notice=""
	show_settings()

func settings_mute() -> void:
	save.data.ses=not save.data.ses
	if settings_return == "menu": play_music(menu_page==1)
	elif not save.data.ses: music.stop()
	show_settings()

func close_settings() -> void:
	if not save.write():
		settings_notice=save.warning
		show_settings()
		return
	leave_settings()

func leave_settings() -> void:
	binding_field=""
	if settings_return == "paused":
		mode="playing"
		pause_game()
	else: show_menu()

func pause_game() -> void:
	if mode != "playing": return
	mode = "paused"
	music.stream_paused = true
	clear_ui()
	label_at("Bir soluklanalım.", Vector2(310, 175), 36)
	button_at("Uçuşa dön", Rect2(330, 250, 300, 52), resume)
	button_at("Ayarlar",Rect2(330,317,300,48),open_settings)
	button_at("Bölüm seçimi",Rect2(330,380,300,48),show_menu)

func resume() -> void:
	play_music(level.get("bolge","")=="liman")
	mode = "playing"
	clear_ui()
	button_at("Ⅱ", Rect2(887, 15, 48, 36), pause_game)

func _physics_process(delta: float) -> void:
	if mode == "playing":
		simulation_accumulator += delta * float(save.data.ayarlar.hiz)
		while simulation_accumulator + 0.0000001 >= 1.0/60 and mode == "playing":
			simulation_accumulator -= 1.0/60
			simulate_step(1.0/60)
	queue_redraw()

func simulate_step(delta: float) -> void:
	if mode == "playing":
		elapsed += delta
		flap_time += delta
		distance += 180.0 * delta
		var wind := FlightEnv.wind_at(level.nesneler,Vector2(distance,bird_y))
		velocity += (850.0 * (1.0 + 0.15 * weight / 6.0) + wind) * delta
		bird_y += velocity * delta
		flash = maxf(0, flash - delta)
		if bird_y < 72 or bird_y > 494:
			finish(false, false)
		else:
			interactions()
		for p in particles:
			p.pos += p.vel * delta
			p.life -= delta
		particles = particles.filter(func(p): return p.life > 0)
	queue_redraw()

func interactions() -> void:
	var bird := Rect2(distance - 13, bird_y - 11, 26, 22)
	for obj in level.nesneler:
		if obj.tur == "sallanan_yuk":
			if bird.intersects(FlightEnv.load_rect(obj,elapsed)):
				finish(false,false)
				return
			continue
		if absf(obj.x - distance) > 130: continue
		if obj.tur == "baca":
			if bird.intersects(Rect2(obj.x - obj.w / 2, obj.y - obj.h / 2, obj.w, obj.h)):
				finish(false, false)
				return
		elif obj.tur == "ganimet" and not collected.has(obj.kimlik):
			if Vector2(distance, bird_y).distance_to(Vector2(obj.x, obj.y)) < 30:
				var heavy: bool = obj.esya == "kasik"
				var amount := 2 if heavy else 1
				if weight + amount <= 6:
					weight += amount
					value += 3 if heavy else 1
					collected[obj.kimlik] = true
					tone(880 if heavy else 650, 0.09)
					for k in range(0 if save.data.ayarlar.az_hareket else 7): particles.append({"pos": Vector2(obj.x - distance + 210, obj.y), "vel": Vector2(randf_range(-65,65),randf_range(-80,20)), "life": 0.5})
				else:
					if message.is_empty(): tone(240, 0.08)
					message = "Çanta dolu — şimdi yuvayı düşün!"
		elif obj.tur == "ozel_esya" and not collected.has(obj.kimlik) and not level.kimlik in save.data.koleksiyon:
			if Vector2(distance,bird_y).distance_to(Vector2(obj.x,obj.y))<30:
				carrying_special = true
				collected[obj.kimlik] = true
				message = "Hatıra sende! Kazanmak için yuvaya teslim et."
				tone(1320,0.18)
		elif obj.tur == "yuva":
			if obj.get("son", false) and distance >= obj.x - 30:
				finish(true, true)
				return
			if not obj.get("son", false) and absf(distance - obj.x) < 43 and absf(bird_y - obj.y) < 42:
				finish(true, false)
				return

func finish(delivered: bool, complete: bool) -> void:
	if mode != "playing": return
	mode = "result"
	if delivered:
		if not save.deliver(level.kimlik, value, complete, token, carrying_special):
			result_title = "Teslim henüz kaydedilemedi"
			result_body = save.warning + "\nKazanç eski kayda eklenmedi. Yeniden kaydetmeyi deneyebilirsin."
			clear_ui()
			label_at(result_title,Vector2(130,160),30)
			label_at(result_body,Vector2(130,220),17)
			button_at("Kaydı yeniden dene",Rect2(210,340,300,48),retry_delivery.bind(complete))
			button_at("Menü",Rect2(535,340,200,48),show_menu)
			return
		result_title = "Yuvaya hoş geldin!" if complete else "Ganimet güvende."
		result_body = "%d değer teslim edildi. Birikim: %d\n" % [value, save.data.bakiye]
		result_body += "Bölüm tamamlandı!" if complete else "Erken teslim yaptın. Bölümü açmak için son yuvaya ulaş."
		if complete and current == levels.size()-1: result_body += "\nŞehir turu tamamlandı! Hatıraların yuvanda seni bekliyor."
		if carrying_special: result_body += "\nHatıra koleksiyonuna eklendi: " + level.ozel_esya_adi
		tone(1046, 0.3)
	else:
		result_title = "Bir kanat daha…"
		result_body = "Taşınan %d değer kayboldu.\nÖnceki teslimlerin güvende: %d\nAtadığın uçuş veya tekrar tuşuyla yeniden dene." % [value, save.data.bakiye]
		tone(160, 0.18)
	clear_ui()
	label_at(result_title, Vector2(210, 152), 38)
	label_at(result_body, Vector2(210, 212), 19)
	button_at("Tekrar uç", Rect2(210, 363, 220, 46), start.bind(current))
	button_at("Bölümler", Rect2(450, 363, 220, 46), show_menu)
	if complete and current + 1 < levels.size():
		button_at("Sonraki bölüm →", Rect2(210, 424, 460, 43), start.bind(current + 1))
	if complete and current == levels.size()-1: button_at("Yuvama dön →",Rect2(210,424,460,43),show_home)
	if not save.warning.is_empty(): label_at(save.warning, Vector2(210, 485), 14)

func retry_delivery(complete: bool) -> void:
	mode="playing"
	finish(true,complete)

func tone(freq: float, duration: float) -> void:
	if not save.data.ses or save.data.ayarlar.efekt<=0: return
	apply_audio_settings()
	var wave := AudioStreamWAV.new()
	wave.format = AudioStreamWAV.FORMAT_16_BITS
	wave.mix_rate = 22050
	var bytes := PackedByteArray()
	var count := int(duration * 22050)
	bytes.resize(count * 2)
	for i in range(count):
		var sample := int(sin(TAU * freq * i / 22050.0) * 6500 * (1.0 - float(i) / count))
		bytes.encode_s16(i * 2, sample)
	wave.data = bytes
	audio.stream = wave
	audio.play()

func text_at(text: String, pos: Vector2, size: int, color: Color) -> void:
	draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)

func _draw() -> void:
	# Higgsfield sanat atlasından hazırlanmış piksel dokular.
	var bg_offset := 0.0 if save.data.ayarlar.az_hareket else fmod(distance * 0.18, 1920.0)
	var backdrop: Texture2D = HARBOR if (mode == "menu" and menu_page == 1) or (mode not in ["menu","home"] and level.get("bolge","") == "liman") else ROOFTOPS
	draw_texture(backdrop, Vector2(-bg_offset, 0))
	draw_texture(backdrop, Vector2(1920-bg_offset, 0))
	draw_rect(Rect2(0, 510, 960, 30), Color("654952"))
	for i in range(32): draw_line(Vector2(i*32, 514), Vector2(i*32+20, 536), Color("9b6f64"), 3)
	if mode in ["menu", "home", "settings"]:
		draw_rect(Rect2(35, 22, 890, 484), Color(0.10,0.14,0.20,0.94))
		if mode == "home":
			draw_texture_rect(NEST,Rect2(115,200,300,150),false)
			draw_texture_rect(CROW[1],Rect2(220,176,100,100),false)
			var decor_row := 0
			for id in Save.DECOR:
				draw_texture_rect(DECOR_ART[id],Rect2(486,164+decor_row*55,32,32),false)
				decor_row += 1
			var positions := {"kumas": Vector2(194,264), "sus": Vector2(325,253), "lamba": Vector2(119,205), "cani": Vector2(381,180)}
			for id in save.data.secili_dekorlar:
				if DECOR_ART.has(id): draw_texture_rect(DECOR_ART[id],Rect2(positions[id],Vector2(64,64)),false)
			if save.completed("LIMAN_04"): draw_texture_rect(MEDAL,Rect2(61,197,64,64),false)
			for i in range(collection_page*8, mini(collection_page*8+8, levels.size())):
				var item: Dictionary = levels[i]
				var icon: Texture2D = SPECIAL_ART.get(item.get("ozel_esya_turu",""),MEDAL)
				draw_texture_rect(icon,Rect2(60+(i%4)*212,395+floori((i%8)/4.0)*27,24,24),false,Color.WHITE if item.kimlik in save.data.koleksiyon else Color(1,1,1,0.3))
		return
	if level.is_empty(): return
	for zone in level.nesneler:
		if zone.tur != "ruzgar": continue
		var zx: float = zone.x-distance+210-zone.w/2
		if zx > 960 or zx+zone.w < 0: continue
		var area := Rect2(zx,zone.y-zone.h/2,zone.w,zone.h)
		draw_rect(area,Color(0.2,0.65,0.76,0.12))
		draw_rect(area,Color(0.3,0.65,0.72,0.65),false,2)
		var up: bool = zone.kuvvet<0
		text_at("YUKARI AKINTI ↑" if up else "AŞAĞI AKINTI ↓",area.position+Vector2(12,22),14,Color("204e60"))
		for k in range(14):
			var py: float = fposmod(k*29.0+(0 if save.data.ayarlar.az_hareket else elapsed)*(-65 if up else 65),zone.h-48)+36
			var start_pos := area.position+Vector2(24+fmod(k*73,zone.w-40),py)
			var end_pos := start_pos+Vector2(0,-12 if up else 12)
			draw_line(start_pos,end_pos,Color("74a9b2"),2)
			draw_line(end_pos,end_pos+Vector2(-4,5 if up else -5),Color("467e92"),2)
			draw_line(end_pos,end_pos+Vector2(4,5 if up else -5),Color("467e92"),2)

	for obj in level.nesneler:
		var x: float = obj.x - distance + 210
		if x < -150 or x > 1100: continue
		var pos := Vector2(x, obj.y)
		if obj.tur == "sallanan_yuk":
			var load_pos := FlightEnv.load_position(obj,elapsed)-Vector2(distance-210,0)
			draw_line(Vector2(x,65),load_pos,Color("73644f"),3)
			draw_line(Vector2(x-100,70),Vector2(x+100,70),Color("a88c54"),8)
			draw_texture_rect(CRATE,Rect2(load_pos-Vector2(obj.w,obj.h)/2,Vector2(obj.w,obj.h)),false)
		elif obj.tur == "ozel_esya" and not collected.has(obj.kimlik) and not level.kimlik in save.data.koleksiyon:
			draw_circle(pos,21,Color(1,0.87,0.38,0.22))
			draw_texture(SPECIAL_ART.get(level.get("ozel_esya_turu",""),MEDAL),pos-Vector2(16,16))
			text_at("HATIRA",pos+Vector2(-26,-27),12,Color("294458"))
		elif obj.tur == "baca":
			var rect := Rect2(x-obj.w/2, obj.y-obj.h/2, obj.w, obj.h)
			# Aynı çarpışma dikdörtgeninde 32 birimlik tuğla döşeme.
			for tx in range(0, int(ceil(rect.size.x)), 32):
				for ty in range(0, int(ceil(rect.size.y)), 32):
					var part := Vector2(minf(32, rect.size.x-tx), minf(32, rect.size.y-ty))
					draw_texture_rect_region(CHIMNEY, Rect2(rect.position+Vector2(tx,ty),part), Rect2(Vector2.ZERO,part))
			var cap_y: float = rect.end.y-12 if obj.y < 200 else rect.position.y-1
			draw_texture_rect(CHIMNEY_CAP, Rect2(rect.position.x-4,cap_y,obj.w+8,18), false)
		elif obj.tur == "ganimet" and not collected.has(obj.kimlik):
			draw_circle(pos, 18, Color(1,0.9,0.5,0.16))
			var loot: Texture2D = SPOON if obj.esya == "kasik" else CAP
			draw_texture(loot, pos - loot.get_size()/2)
		elif obj.tur == "yuva":
			var final: bool = obj.get("son",false)
			if final:
				draw_rect(Rect2(x-38,75,76,425),Color(0.8,1,0.7,0.14))
			else:
				draw_circle(pos,48,Color(0.8,1,0.7,0.17))
			var nest_art: Texture2D = NEST_FINAL if final else NEST
			draw_texture(nest_art, pos+Vector2(-64,-36))
			text_at("SON YUVA" if final else "ERKEN TESLİM ↓",pos+Vector2(-65,-52),15,Color("243c3d"))
			if not final: text_at("Alt yola gir",pos+Vector2(-43,53),13,Color("243c3d"))
	var bird := Vector2(210,bird_y)
	var frame := mini(int(flap_time / 0.075), 3)
	draw_texture(CROW[frame], bird-Vector2(32,32))
	if weight > 0:
		draw_line(bird+Vector2(0,10),bird+Vector2(0,23),Color("bd9877"),2)
		draw_circle(bird+Vector2(0,23),5+weight,Color("af805e"))
	for p in particles: draw_circle(p.pos, 3, Color("fff0aa"))
	draw_rect(Rect2(0,0,960,63),Color("223043"))
	text_at("%02d  %s" % [current+1,level.ad],Vector2(24,28),19,Color("fff1d2"))
	text_at("Ganimet %d◇%s" % [value, "  ★" if carrying_special else ""],Vector2(365,28),19,Color("f6d277"))
	text_at("YÜK",Vector2(557,28),13,Color("fff1d2"))
	for i in range(6): draw_rect(Rect2(597+i*20,15,14,16),Color("e9b76b") if i<weight else Color("475160"))
	draw_rect(Rect2(24,45,810,4),Color("475160"))
	draw_rect(Rect2(24,45,810*clampf(distance/level.uzunluk,0,1),4),Color("e9b76b"))
	text_at(message if not message.is_empty() else flight_key_name()+" / TIKLA: kanat çırp     ESC: duraklat",Vector2(24,533),14,Color("fff1d2"))
	if mode in ["ready","paused","result"]:
		draw_rect(Rect2(0,64,960,446),Color(0.09,0.13,0.19,0.89))
