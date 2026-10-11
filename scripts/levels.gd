class_name LevelStore
extends RefCounted

static func read_json(path: String) -> Variant:
	if not FileAccess.file_exists(path): return null
	var parser := JSON.new()
	if parser.parse(FileAccess.get_file_as_string(path)) != OK: return null
	return parser.data

static func load_levels(catalog_path: String = "res://data/level_catalog.json") -> Dictionary:
	var result := {"levels": [], "errors": []}
	var catalog = read_json(catalog_path)
	if not catalog is Array:
		result.errors.append("Bölüm kataloğu okunamadı.")
		return result
	var ids := {}
	for entry in catalog:
		if not entry is Dictionary or not entry.get("dosya") is String or not entry.get("onceki", "") is String:
			result.errors.append("Geçersiz katalog girdisi")
			continue
		var path: String = entry.get("dosya", "")
		var data = read_json(path)
		var error := validate(data)
		if error.is_empty() and ids.has(data.kimlik):
			error = "Yinelenen bölüm kimliği"
		if error.is_empty() and not str(entry.get("onceki", "")).is_empty() and not ids.has(entry.onceki):
			error = "Önkoşul daha önce tanımlanmalı"
		if not error.is_empty():
			result.errors.append(path + ": " + error)
			continue
		data["onceki"] = entry.get("onceki", "")
		ids[data.kimlik] = true
		result.levels.append(data)
	return result

static func validate(data: Variant) -> String:
	if not data is Dictionary:
		return "Geçersiz JSON nesnesi"
	for key in ["kimlik", "ad", "uzunluk", "nesneler", "sema_surumu", "ipucu", "deger_hedefi", "bolge", "ozel_esya_adi"]:
		if not data.has(key):
			return "Eksik alan: " + key
	for key in ["kimlik","ad","ipucu","bolge","ozel_esya_adi"]:
		if not data[key] is String or data[key].is_empty(): return "Geçersiz metin: " + key
	if not data.bolge in ["cati","liman"]: return "Bilinmeyen bölge teması"
	if not (data.deger_hedefi is float or data.deger_hedefi is int) or data.deger_hedefi<0 or not is_finite(float(data.deger_hedefi)): return "Geçersiz değer hedefi"
	if data.sema_surumu != 1 or not data.nesneler is Array:
		return "Desteklenmeyen şema"
	if not data.uzunluk is float and not data.uzunluk is int:
		return "Uzunluk sayı olmalı"
	if data.uzunluk <= 1000 or not is_finite(float(data.uzunluk)):
		return "Geçersiz uzunluk"
	var seen := {}
	var ends := 0
	var specials := 0
	for obj in data.nesneler:
		if not obj is Dictionary:
			return "Geçersiz nesne"
		for key in ["kimlik", "tur", "x", "y"]:
			if not obj.has(key):
				return "Nesnede eksik alan: " + key
		if not obj.kimlik is String or obj.kimlik.is_empty() or not obj.tur is String: return "Geçersiz nesne kimliği/türü"
		if seen.has(obj.kimlik):
			return "Yinelenen nesne: " + str(obj.kimlik)
		seen[obj.kimlik] = true
		if not obj.tur in ["baca", "ganimet", "yuva", "ozel_esya", "ruzgar", "sallanan_yuk"]:
			return "Bilinmeyen tür: " + str(obj.tur)
		for key in ["x", "y"]:
			if not (obj[key] is float or obj[key] is int) or not is_finite(float(obj[key])):
				return str(obj.kimlik) + ": geçersiz " + key
		if obj.x < 0 or obj.x > data.uzunluk or obj.y < 0 or obj.y > 540:
			return str(obj.kimlik) + ": sınır dışı"
		if obj.tur in ["baca", "ruzgar", "sallanan_yuk"]:
			if not (obj.get("w") is int or obj.get("w") is float) or not (obj.get("h") is int or obj.get("h") is float):
				return str(obj.kimlik) + ": boyutlar sayı olmalı"
			if not is_finite(float(obj.w)) or not is_finite(float(obj.h)) or obj.w <= 0 or obj.h <= 0:
				return str(obj.kimlik) + ": geçersiz boyut"
		if obj.tur == "ruzgar" and (obj.w<=40 or obj.h<=48): return "Rüzgâr alanı görselleştirilemeyecek kadar küçük"
		if obj.tur == "ozel_esya": specials += 1
		if obj.tur == "yuva" and not obj.get("son",false) is bool: return "Geçersiz yuva tipi"
		if obj.tur == "ruzgar":
			if not (obj.get("kuvvet") is float or obj.get("kuvvet") is int) or not is_finite(float(obj.kuvvet)) or absf(obj.kuvvet) > 350:
				return str(obj.kimlik) + ": geçersiz rüzgâr kuvveti"
		if obj.tur == "sallanan_yuk":
			for field in ["periyot", "genlik", "evre"]:
				if not (obj.get(field) is float or obj.get(field) is int) or not is_finite(float(obj[field])):
					return str(obj.kimlik) + ": geçersiz " + field
			if obj.periyot <= 0 or obj.genlik < 0 or obj.genlik > 160:
				return str(obj.kimlik) + ": geçersiz hareket aralığı"
		if obj.tur == "ganimet" and not obj.get("esya", "") in ["kapak", "kasik"]:
			return str(obj.kimlik) + ": bilinmeyen eşya"
		if obj.tur == "yuva" and obj.get("son", false):
			ends += 1
			if obj.x < 1000:
				return "Son yuva başlangıçtan sonra olmalı"
	if specials != 1: return "Tam bir özel eşya gerekli"
	if ends != 1:
		return "Tam bir son yuva gerekli"
	return ""
