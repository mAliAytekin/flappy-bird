extends SceneTree
func _initialize() -> void:
	call_deferred("capture")
func snap(name: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://previews/"+name+".png")
func capture() -> void:
	var game = load("res://scripts/game.gd").new()
	root.add_child(game)
	game.set_physics_process(false)
	game.save = load("res://scripts/save_store.gd").new()
	game.save.path = "user://phase2_preview_"+str(Time.get_ticks_usec())+".json"
	game.save.data.ses = false
	game.menu_page=1
	game.show_menu()
	await snap("phase2-menu")
	game.start(6)
	game.begin()
	game.distance=2520
	game.bird_y=290
	game.elapsed=1.1
	game.queue_redraw()
	await snap("phase2-wind")
	game.start(5)
	game.begin()
	game.distance=1800
	game.bird_y=295
	game.elapsed=1.1
	game.queue_redraw()
	await snap("phase2-crane")
	game.save.data.bakiye=12
	game.save.data.dekorlar=["kumas","sus","lamba","cani"]
	game.save.data.secili_dekorlar=game.save.data.dekorlar.duplicate()
	game.save.data.koleksiyon=["CATI_01","LIMAN_04"]
	game.save.data.bolumler["LIMAN_04"]={"tamam":true,"en_iyi":8}
	game.show_home()
	await snap("phase2-home")
	game.start(7)
	game.begin()
	game.carrying_special=true
	game.finish(true,true)
	await snap("phase2-finale")
	for suffix in ["", ".bak", ".tmp"]:
		if FileAccess.file_exists(game.save.path+suffix): DirAccess.remove_absolute(game.save.path+suffix)
	game.queue_free()
	await process_frame
	quit()
