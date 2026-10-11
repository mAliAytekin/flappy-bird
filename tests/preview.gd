extends SceneTree
func _initialize() -> void:
	call_deferred("capture")
func capture() -> void:
	var game = load("res://scripts/game.gd").new()
	root.add_child(game)
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/tmp/parlak-menu.png")
	game.start(2)
	game.begin()
	game.set_physics_process(false)
	game.distance = 1930
	game.bird_y = 280
	game.weight = 3
	game.value = 4
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/tmp/parlak-game.png")
	game.start(1)
	game.begin()
	game.set_physics_process(false)
	game.distance = 6280
	game.bird_y = 330
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/tmp/parlak-nest.png")
	game.distance = 10600
	game.queue_redraw()
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/tmp/parlak-final-nest.png")
	quit()
