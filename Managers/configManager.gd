extends Node

const CONFIG_SCHEMAS = {
	"post_office.cfg": {
		"salary": {
			"type": "int",
			"min": 1,
			"max": 10,
			"default":1,
			"permission":1,
			
			"apply":"_apply_post_office_salary"
		},
		"work_days": {
			"type": "int",
			"min": 1,
			"max": 7,
			"permission":1,
			
			"apply":"_apply_post_office_work_days"
		}
	},
	"player.cfg": {
		"walk_speed": {
			"type": "int",
			"min": 50,
			"max": 300,
			"permission":1,
			
			"apply":"_apply_player_walk_speed"
		},
	},
	"school.cfg": {
		"school_days": {
			"type": "int",
			"min": 3,
			"max": 7,
			"permission":1,
			
			"apply":"_apply_player_school_days"
		},
		"recap_tribute": {
			"type": "int",
			"min": 0,
			"max": 7,
			"permission":1,
			
			"apply":"_apply_player_recap_tribute"
		},
	},
}

const PERMISSION_UNLOCKS = {
	1: [
		{
			"path": ["config", "post_office.cfg"],
			"template": "post_office"
		},
		{
			"path": ["config", "player.cfg"],
			"template": "player"
		},
		{
			"path": ["config", "school.cfg"],
			"template": "school"
		}
	],
	2: [
		
	]
}

func set_config_value(file_name: String, key: String, value) -> bool:
	var filesystem = MenuFileManager.load_filesystem()
	if !filesystem.has("config"):
		push_warning("Config directory not found.")
		return false

	var config_dir = filesystem["config"]
	if !config_dir.has(file_name):
		push_warning("Config file not found: " + file_name)
		return false

	var file = config_dir[file_name]
	if !file.has("content"):
		push_warning("Config file has no content: " + file_name)
		return false

	var lines = file["content"].split("\n")
	var found := false
	for i in range(lines.size()):
		var line = lines[i]
		var trimmed = line.strip_edges()
		if trimmed.is_empty() or trimmed.begins_with("#"):
			continue

		if trimmed.begins_with("["):
			continue
		var split = trimmed.split("=")
		if split.size() != 2:
			continue

		var current_key = split[0].strip_edges()
		if current_key == key:
			lines[i] = "%s = %s" % [key, str(value)]
			found = true
			break

	if !found:
		lines.append("%s = %s" % [key, str(value)])
	file["content"] = "\n".join(lines)
	MenuFileManager.save_filesystem(filesystem)
	on_config_saved(["config", file_name])

	return true

func on_config_saved(path: Array):
	var filesystem = MenuFileManager.load_filesystem()
	var data = MenuFileManager.get_data_by_path(filesystem, path)
	var parse_result = parse_config(data["content"])
	if !parse_result["success"]:
		return {
			"success": false,
			"type": "parser",
			"messages": parse_result["errors"]
		}

	var config = parse_result["config"]
	var file_name = path[path.size() - 1]
	var validation = validate_config(file_name, config)
	if !validation["success"]:
		return {
			"success": false,
			"type": "validation",
			"messages": validation["errors"]
		}

	apply_config(path, config)
	return {
		"success": true,
		"type": "success",
		"messages": ["Configuration applied successfully."]
	}

func load_all_configs():
	var filesystem = MenuFileManager.load_filesystem()
	var config = filesystem.get("config", {})
	for file_name in config.keys():
		if !file_name.ends_with(".cfg"):
			continue
		on_config_saved(["config", file_name])

func is_config_file(path:Array) -> bool:
	if path.is_empty():
		return false
	return path[path.size()-1].ends_with(".cfg")


func is_config_directory(path:Array) -> bool:
	if path.is_empty():
		return false
	return path[0] == "config"



func unlock_permission_level(level:int):
	print("UNLOCK PERMISSION:", level)
	if Global.permission_level >= level:
		return
	Global.set_permission_level(level)
	if !PERMISSION_UNLOCKS.has(level):
		return
	MenuFileManager.create_directory(["config"])
	for file in PERMISSION_UNLOCKS[level]:
		print(PERMISSION_UNLOCKS[level])
		MenuFileManager.create_text_file(file.path,load_template(file.template))

func load_template(name:String)->String:
	return FileAccess.get_file_as_string(
		"res://config_templates/%s.cfg" % name
	)

func parse_config(text:String) -> Dictionary:
	var result = {
		"success": true,
		"config": {},
		"sections": [],
		"errors": []
	}

	var lines = text.split("\n")
	for i in range(lines.size()):
		var line_number = i + 1
		var line = lines[i].strip_edges()
		# Empty line
		if line.is_empty():
			continue
		# Comment
		if line.begins_with("#"):
			continue
		# Section
		if line.begins_with("["):
			if !line.ends_with("]"):
				result["success"] = false
				result["errors"].append("Line %d: Missing closing ']'." % line_number)
				continue
			var section_name = line.substr(1, line.length() - 2).strip_edges()
			if section_name in result["sections"]:
				result["success"] = false
				result["errors"].append("Line %d: Duplicate section '%s'." % [line_number, section_name])
				continue
			if section_name.is_empty():
				result["success"] = false
				result["errors"].append("Line %d: Empty section name." % line_number)
				continue
			result["sections"].append(section_name)
			continue
		# Variable
		var split = line.split("=")
		if split.size() != 2:
			result["success"] = false
			result["errors"].append("Line %d: Expected format 'key = value'." % line_number)
			continue
		var key = split[0].strip_edges()
		var value = split[1].strip_edges()
		if key.is_empty():
			result["success"] = false
			result["errors"].append("Line %d: Missing variable name." % line_number)
			continue
		if value.is_empty():
			result["success"] = false
			result["errors"].append("Line %d: Missing value." % line_number)
			continue
		if result["config"].has(key):
			result["success"] = false
			result["errors"].append("Line %d: Duplicate variable '%s'." % [line_number, key])
			continue
		result["config"][key] = value
	return result

func validate_config(file_name:String, config:Dictionary) -> Dictionary:
	var result = {
		"success": true,
		"errors": []
	}

	if !CONFIG_SCHEMAS.has(file_name):
		return result

	var schema = CONFIG_SCHEMAS[file_name]
	for key in config.keys():
		if !schema.has(key):
			result.success = false
			result.errors.append("Unknown parameter: " + key)
			continue
		var rule = schema[key]
		var value = config[key]
		match rule.type:
			"int":
				if !value.is_valid_int():
					result.success = false
					result.errors.append("%s must be integer" % key)
					continue

				var number = int(value)

				if rule.has("min") and number < rule.min:
					result.success = false
					result.errors.append("%s is below minimum (%d)" % [key, rule.min])

				if rule.has("max") and number > rule.max:
					result.success = false
					result.errors.append("%s exceeds maximum (%d)" % [key, rule.max])
	print("validating done")
	return result


func apply_config(path: Array, config: Dictionary):
	var file_name = path[path.size() - 1]

	if !CONFIG_SCHEMAS.has(file_name):
		return

	var schema = CONFIG_SCHEMAS[file_name]
	for key in config.keys():
		if !schema.has(key):
			continue

		var rule = schema[key]
		if !rule.has("apply"):
			print("apply schema doesnt contain apply keyword")
			print(key)
			continue

		var function_name = rule["apply"]
		if has_method(function_name):
			call(function_name, config[key])
		else:
			push_error("Config apply function not found: " + function_name)


func _apply_player_walk_speed(value):
	Global.player_max_speed = int(value)

func _apply_post_office_salary(value):
	Global.post_office_salary = int(value)

func _apply_post_office_work_days(value):
	Global.post_office_work_days = int(value)

func _apply_player_school_days(value):
	Global.school_days = int(value)

func _apply_player_recap_tribute(value):
	Global.recap_tribute = int(value)
