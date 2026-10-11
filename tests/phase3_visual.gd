extends SceneTree
var game: Node
func _initialize() -> void:
	call_deferred("run")
func snapshot(name: String) -> void:
	game.queue_redraw()
	for i in range(5): await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://previews/"+name+".png")
func run() -> void:
	game=load("res://scripts/game.gd").new()
	root.add_child(game)
	game.set_physics_process(false)
	game.save=load("res://scripts/save_store.gd").new()
	game.save.path="user://phase3_visual_"+str(Time.get_ticks_usec())+".json"
	game.save.data.ses=false
	for size in [Vector2i(640,360),Vector2i(1280,720),Vector2i(1440,900)]:
		root.size=size
		game.show_menu()
		game.open_settings()
		await snapshot("phase3-settings-%dx%d" % [size.x,size.y])
		game.show_home()
		await snapshot("phase3-home-%dx%d" % [size.x,size.y])
	root.size=Vector2i(1280,720)
	game.start(7)
	game.begin()
	game.save.data.ayarlar.az_hareket=true
	game.distance=2600
	game.elapsed=1.2
	await snapshot("phase3-reduced-motion")
	game.save.data.ayarlar.az_hareket=false
	# Görünür çizim yükünün en yüksek olduğu pencereyi seç.
	var highest:=-1.0
	var best_level:=0
	var best_x:=160.0
	for index in range(game.levels.size()):
		var section: Dictionary=game.levels[index]
		for x in range(160,int(section.uzunluk)-900,100):
			var score:=0.0
			for obj in section.nesneler:
				if obj.x>=x-350 and obj.x<=x+900:
					score+=obj.w*obj.h/1024.0 if obj.tur=="baca" else (42.0 if obj.tur=="ruzgar" else 5.0)
			if score>highest:
				highest=score
				best_level=index
				best_x=x
	game.start(best_level)
	game.begin()
	game.distance=best_x
	game.bird_y=280
	for i in range(120):
		game.elapsed+=1.0/60
		game.queue_redraw()
		await process_frame
	var times: Array[float]=[]
	var cpu: Array[float]=[]
	var previous:=Time.get_ticks_usec()
	for i in range(480):
		game.elapsed+=1.0/60
		game.queue_redraw()
		await process_frame
		var now:=Time.get_ticks_usec()
		times.append((now-previous)/1000.0)
		cpu.append(Performance.get_monitor(Performance.TIME_PROCESS)*1000)
		previous=now
	var total:=0.0
	for value in times: total+=value
	times.sort()
	cpu.sort()
	var report:={"bolum":game.level.kimlik,"konum":best_x,"kare":times.size(),"cozunurluk":"1280x720","ortalama_fps":1000.0/(total/times.size()),"medyan_ms":times[times.size()/2],"p95_ms":times[int(times.size()*.95)],"p95_islem_ms":cpu[int(cpu.size()*.95)],"gpu":RenderingServer.get_video_adapter_name(),"godot":Engine.get_version_info().string,"not":"Gerçek pencerede yoğun görünür sahne, 120 ısınma + 480 ölçüm karesi; bütün cihazlar için garanti değildir."}
	var file:=FileAccess.open("res://tests/phase3-performance.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"  "))
	file.close()
	print(JSON.stringify(report))
	await snapshot("phase3-performance")
	game.queue_free()
	await process_frame
	quit()
