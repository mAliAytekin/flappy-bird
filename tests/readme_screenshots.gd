extends SceneTree

# README görselleri için yalnızca bellekte örnek ilerleme oluşturur.
func _initialize() -> void:
	call_deferred("capture")

func snap(name: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	var error = root.get_texture().get_image().save_png("res://previews/readme/" + name + ".png")
	assert(error == OK, "Ekran görüntüsü kaydedilemedi: " + name)

func capture() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://previews/readme"))
	root.size = Vector2i(1280, 720)
	var game = load("res://scripts/game.gd").new()
	root.add_child(game)
	game.set_physics_process(false)
	# Otomatik çekim sırasında pencere odağı görüntüyü duraklatmasın.
	for connection in root.focus_exited.get_connections():
		root.focus_exited.disconnect(connection.callable)
	game.save = load("res://scripts/save_store.gd").new()
	game.save.writable = false
	game.save.data.ses = false
	game.music.stop()
	for index in range(4):
		game.save.data.bolumler[game.levels[index].kimlik] = {"tamam": true, "en_iyi": 8}
	game.save.data.bakiye = 12
	game.save.data.koleksiyon = ["CATI_01", "CATI_02", "LIMAN_04"]
	game.save.data.dekorlar = ["kumas", "sus", "lamba", "cani"]
	game.save.data.secili_dekorlar = game.save.data.dekorlar.duplicate()
	game.show_menu()
	await snap("bolum-secimi")
	game.start(2)
	game.begin()
	game.distance = 1800
	game.bird_y = 280
	game.weight = 3
	game.value = 4
	game.elapsed = 1.1
	game.queue_redraw()
	await snap("catilarda-ucus")
	game.start(6)
	game.begin()
	game.distance = 2520
	game.bird_y = 290
	game.weight = 3
	game.value = 4
	game.elapsed = 1.1
	game.queue_redraw()
	await snap("limanda-ruzgar")
	game.start(5)
	game.begin()
	game.distance = 1800
	game.bird_y = 295
	game.elapsed = 1.1
	game.queue_redraw()
	await snap("limanda-vinc")
	game.show_home()
	await snap("yuvam")
	game.settings_return = "menu"
	game.show_settings()
	await snap("ayarlar")
	game.queue_free()
	await process_frame
	print("README: 6 ekran görüntüsü kaydedildi; oyuncu kaydı değiştirilmedi.")
	quit()
