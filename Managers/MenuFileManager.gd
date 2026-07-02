extends Node

const PLAYER_FILESYSTEM_PATH = "user://menu_filesystem.json"
const UNLOCKED_ENTRIES_PATH = "user://unlocked_menu_entries.json"
const GLOBAL_DATA_PATH = "user://global_data.json"

#function for game start
func initialize():
	Global.set_permission_level(MenuFileManager.get_global_value("permission_level",0))

func load_global_data() -> Dictionary:
	if not FileAccess.file_exists(GLOBAL_DATA_PATH):
		return {}

	var file = FileAccess.open(GLOBAL_DATA_PATH, FileAccess.READ)

	if file == null:
		return {}

	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if data is Dictionary:
		return data

	return {}

func save_global_data(data: Dictionary):

	var file = FileAccess.open(GLOBAL_DATA_PATH, FileAccess.WRITE)

	if file == null:
		return

	file.store_string(JSON.stringify(data, "\t"))
	file.close()

func get_global_value(key: String, default_value = null):

	var data = load_global_data()

	return data.get(key, default_value)

func set_global_value(key: String, value):

	var data = load_global_data()

	data[key] = value

	save_global_data(data)

func set_global_values(values: Dictionary):

	var data = load_global_data()

	for key in values.keys():
		data[key] = values[key]

	save_global_data(data)

func reset_global_data():

	save_global_data({})






func load_filesystem() -> Dictionary:
	if not FileAccess.file_exists(PLAYER_FILESYSTEM_PATH):
		return {}

	var file = FileAccess.open(PLAYER_FILESYSTEM_PATH, FileAccess.READ)

	if file == null:
		return {}

	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if data is Dictionary:
		return data

	return {}


func save_filesystem(filesystem: Dictionary):
	var file = FileAccess.open(PLAYER_FILESYSTEM_PATH, FileAccess.WRITE)

	if file == null:
		print("Failed to save filesystem")
		return

	file.store_string(JSON.stringify(filesystem, "\t"))
	file.close()


func get_data_by_path(filesystem: Dictionary, path: Array):
	var current = filesystem

	for part in path:
		if current.has(part):
			current = current[part]
		else:
			return null

	return current


func get_parent_directory(filesystem: Dictionary, path: Array):
	if path.size() <= 1:
		return filesystem

	var current = filesystem

	for i in range(path.size() - 1):
		var part = path[i]

		if not current.has(part):
			current[part] = {}

		current = current[part]

	return current


func create_text_file(path: Array, content: String = "") -> bool:
	print("Creating:", path)
	var filesystem = load_filesystem()

	if path.is_empty():
		return false

	var file_name = path[path.size() - 1]

	var parent = get_parent_directory(filesystem, path)

	if parent.has(file_name):
		return false

	parent[file_name] = {
		"type": "text",
		"content": content
	}

	save_filesystem(filesystem)
	return true


func append_to_text_file(path: Array, text: String) -> bool:
	var filesystem = load_filesystem()

	var data = get_data_by_path(filesystem, path)

	if data == null:
		return false

	if not data.has("type"):
		return false

	if data["type"] != "text":
		return false

	data["content"] += text

	save_filesystem(filesystem)
	return true


func create_directory(path: Array) -> bool:
	var filesystem = load_filesystem()

	var current = filesystem

	for part in path:
		if not current.has(part):
			current[part] = {}

		current = current[part]

	save_filesystem(filesystem)
	return true

func create_or_append(path: Array, text: String) -> bool:
	var filesystem = load_filesystem()

	var data = get_data_by_path(filesystem, path)

	if data == null:
		var file_name = path[path.size() - 1]
		var parent = get_parent_directory(filesystem, path)

		parent[file_name] = {
			"type": "text",
			"content": text
		}

		save_filesystem(filesystem)
		return true

	if not data.has("type"):
		return false

	if data["type"] != "text":
		return false

	if text in data["content"]:
		return true

	data["content"] += text

	save_filesystem(filesystem)
	return true





func load_unlocked_entries() -> Dictionary:
	if not FileAccess.file_exists(UNLOCKED_ENTRIES_PATH):
		return {}

	var file = FileAccess.open(UNLOCKED_ENTRIES_PATH, FileAccess.READ)

	if file == null:
		return {}

	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if data is Dictionary:
		return data

	return {}

func save_unlocked_entries(entries: Dictionary):
	var file = FileAccess.open(UNLOCKED_ENTRIES_PATH, FileAccess.WRITE)

	if file == null:
		return

	file.store_string(JSON.stringify(entries, "\t"))
	file.close()

func is_entry_unlocked(entry_id: String) -> bool:
	var entries = load_unlocked_entries()
	return entries.has(entry_id)

func unlock_entry(entry_id: String):
	var entries = load_unlocked_entries()

	entries[entry_id] = true

	save_unlocked_entries(entries)

func unlock_menu_entry(entry_id: String, path: Array, text: String):

	if is_entry_unlocked(entry_id):
		return

	create_or_append(path, text)

	unlock_entry(entry_id)
	
	show_notification(path)

func show_notification(path: Array):

	var scene = get_tree().current_scene

	if scene == null:
		return

	var popup = scene.get_node_or_null("Popups/FileNotificationPopup")

	if popup == null:
		print("notification node not found")
		return

	popup.file_created("/".join(path))


func reset_unlocked_entries():
	var file = FileAccess.open(
		UNLOCKED_ENTRIES_PATH,
		FileAccess.WRITE
	)

	if file == null:
		return

	file.store_string("{}")
	file.close()
