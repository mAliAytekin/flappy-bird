class_name SaveStore
extends RefCounted
var path := "user://ilerleme.json"
const DECOR := {"kumas": {"ad": "Yumuşak kumaş", "fiyat": 3}, "sus": {"ad": "Kapak süsü", "fiyat": 5}, "lamba": {"ad": "Küçük lamba", "fiyat": 7}, "cani": {"ad": "Rüzgâr çanı", "fiyat": 9}}
const SETTINGS := {"ucus_tusu": KEY_SPACE, "duraklat_tusu": KEY_P, "tekrar_tusu": KEY_R, "hiz": 1.0, "az_hareket": false, "muzik": 0.65, "efekt": 0.8}
var data := {"surum": 3, "ayarlar": SETTINGS.duplicate(), "koleksiyon": [], "dekorlar": [], "secili_dekorlar": [], "bakiye": 0, "bolumler": {}, "ses": true, "son_oturum": ""}
var warning := ""
var writable := true

func read() -> void:
	if not FileAccess.file_exists(path):
		return
	warning = ""
	writable = true
	var raw := JSON.new()
	if raw.parse(FileAccess.get_file_as_string(path)) == OK and raw.data is Dictionary:
		var version = raw.data.get("surum",0)
		if (version is float or version is int) and version > 3:
			warning = "Kayıt daha yeni bir oyun sürümüne ait; üzerine yazılmayacak."
			writable = false
			return
	var loaded = parse(path)
	if loaded == null:
		loaded = parse(path + ".bak")
		warning = "Kayıt yedekten kurtarıldı."
	if loaded == null:
		warning = "Kayıt okunamadı. Eski dosya korundu; bu oturum kaydedilmeyecek."
		writable = false
		return
	data.merge(loaded, true)
	data.surum = 3
	var settings: Dictionary = SETTINGS.duplicate()
	settings.merge(data.get("ayarlar", {}), true)
	data.ayarlar = settings

func parse(file: String) -> Variant:
	if not FileAccess.file_exists(file):
		return null
	var parser := JSON.new()
	if parser.parse(FileAccess.get_file_as_string(file)) != OK:
		return null
	var value = parser.data
	if not value is Dictionary or (value.get("surum", 0) != 1 and value.get("surum", 0) != 2 and value.get("surum", 0) != 3):
		return null
	if not value.get("bolumler") is Dictionary or not (value.get("bakiye") is float or value.get("bakiye") is int):
		return null
	if value.bakiye < 0 or not is_finite(float(value.bakiye)):
		return null
	for record in value.bolumler.values():
		if not record is Dictionary or not record.get("tamam", false) is bool:
			return null
		if not (record.get("en_iyi", 0) is float or record.get("en_iyi", 0) is int):
			return null
	if value.has("ses") and not value.ses is bool:
		return null
	for field in ["koleksiyon", "dekorlar", "secili_dekorlar"]:
		if value.has(field) and not value[field] is Array:
			return null
		if value.has(field):
			var seen := {}
			for item in value[field]:
				if not item is String or item.is_empty() or seen.has(item): return null
				seen[item] = true
	if value.has("son_oturum") and not value.son_oturum is String: return null
	if value.has("ayarlar"):
		if not value.ayarlar is Dictionary: return null
		var keys := {}
		for field in SETTINGS:
			var setting = value.ayarlar.get(field, SETTINGS[field])
			if field == "az_hareket":
				if not setting is bool: return null
			else:
				if not (setting is float or setting is int) or not is_finite(float(setting)): return null
				if field.ends_with("tusu"):
					if setting <= 0 or setting != int(setting) or setting == KEY_ESCAPE or keys.has(str(setting)): return null
					keys[str(setting)] = true
				elif field == "hiz":
					if setting != 1.0 and setting != 0.75 and setting != 0.5: return null
				elif setting < 0 or setting > 1: return null
	return value

func write() -> bool:
	if not writable:
		return false
	var file := FileAccess.open(path + ".tmp", FileAccess.WRITE)
	if file == null:
		warning = "Kayıt yazılamadı."
		return false
	file.store_string(JSON.stringify(data))
	file.close()
	if parse(path + ".tmp") == null:
		warning = "Yeni kayıt doğrulanamadı; eski kayıt korundu."
		return false
	if parse(path) != null:
		if DirAccess.copy_absolute(path, path + ".bak") != OK:
			warning = "Yedek oluşturulamadı; eski kayıt korundu."
			return false
	var ok := DirAccess.rename_absolute(path + ".tmp", path) == OK
	if not ok:
		warning = "Kayıt diske aktarılamadı."
	else:
		warning = ""
	return ok

func deliver(id: String, amount: int, complete: bool, token: String, special: bool = false) -> bool:
	if data.son_oturum == token or amount < 0 or not writable:
		return false
	var snapshot: Dictionary = data.duplicate(true)
	data.son_oturum = token
	data.bakiye += amount
	var previous: Dictionary = data.bolumler.get(id, {})
	data.bolumler[id] = {"tamam": complete or previous.get("tamam", false), "en_iyi": maxi(amount, int(previous.get("en_iyi", 0)))}
	if special and not id in data.koleksiyon:
		data.koleksiyon.append(id)
	if not write():
		data = snapshot
		return false
	return true

func completed(id: String) -> bool:
	return data.bolumler.get(id, {}).get("tamam", false)

func purchase(id: String) -> bool:
	if not DECOR.has(id) or id in data.dekorlar or not writable:
		return false
	var price: int = DECOR[id].fiyat
	if data.bakiye < price: return false
	var previous: Dictionary = data.duplicate(true)
	data.bakiye -= price
	data.dekorlar.append(id)
	data.secili_dekorlar.append(id)
	if not write():
		data = previous
		return false
	return true

func toggle_decor(id: String) -> void:
	if not id in data.dekorlar: return
	var snapshot: Dictionary = data.duplicate(true)
	if id in data.secili_dekorlar: data.secili_dekorlar.erase(id)
	else: data.secili_dekorlar.append(id)
	if not write(): data = snapshot
