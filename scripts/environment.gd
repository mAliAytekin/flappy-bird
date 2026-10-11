class_name FlightEnvironment
extends RefCounted

static func wind_at(objects: Array, point: Vector2) -> float:
	var force := 0.0
	for obj in objects:
		if obj.tur == "ruzgar" and Rect2(obj.x-obj.w/2, obj.y-obj.h/2, obj.w, obj.h).has_point(point):
			force += float(obj.kuvvet)
	return clampf(force, -350, 350)

static func load_position(obj: Dictionary, time: float) -> Vector2:
	return Vector2(obj.x + sin(time * TAU / obj.periyot + obj.get("evre", 0.0)) * obj.genlik, obj.y)

static func load_rect(obj: Dictionary, time: float) -> Rect2:
	return Rect2(load_position(obj, time) - Vector2(obj.w, obj.h)/2, Vector2(obj.w, obj.h))
