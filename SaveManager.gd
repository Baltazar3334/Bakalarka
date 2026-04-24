extends Node

const SAVE_PATH = "user://save"
var current_save_slot: int = -1
var loaded_data: Dictionary = {}

func perform_quick_save():
	var scene = get_tree().current_scene
	if scene == null:
		print("scene is null")
		return null

	var player = scene.get_node("player")
	
	if player == null:
		print("Error: player node is null!")
		return

	var data = {
		"player_position": player.global_position,
		"flags": player.flags,
		"inventory": InventoryManager.inventory,
		"dropped_items": get_dropped_items_data()
	}
	
	if current_save_slot == -1:
		print("No save slot selected!")
		return
	
	save_game(current_save_slot, data)
	print("Quick saved to slot ", current_save_slot)

func save_game(slot:int, data:Dictionary):
	var file = FileAccess.open(SAVE_PATH + str(slot) + ".save", FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_game(slot:int) -> Dictionary:
	var path = SAVE_PATH + str(slot) + ".save"
	var file = FileAccess.open(path, FileAccess.READ)
	var data = file.get_var()
	file.close()
	print(data)
	return data

func save_exists(slot:int) -> bool:
	return FileAccess.file_exists(SAVE_PATH + str(slot) + ".save")


func load_game_to_scene(slot:int, scene_path:String = "res://main.tscn") -> void:
	if not save_exists(slot):
		print("Save not found for slot ", slot)
		return

	current_save_slot = slot
	loaded_data = load_game(slot)

	Transitioner.change_scene(scene_path)
	call_deferred("_finish_loading_game_async")

func _finish_loading_game_async() -> void:
	while get_tree().current_scene == null or get_tree().current_scene.name == "MainMenuV3":
		await get_tree().process_frame

	clear_dropped_items()

	if loaded_data.has("inventory"):
		InventoryManager.set_loaded_inventory(loaded_data["inventory"])

	if loaded_data.has("dropped_items"):
		load_dropped_items(loaded_data["dropped_items"])

func delete_save(slot: int) -> bool:
	var path = SAVE_PATH + str(slot) + ".save"
	
	if not FileAccess.file_exists(path):
		print("trying to delete a save with a wrong path")
		return false
	
	var result = DirAccess.remove_absolute(path)
	
	if result == OK:
		if current_save_slot == slot:
			current_save_slot = -1
			loaded_data = {}
		return true
	
	return false


func load_dropped_items(items_data: Array):
	var item_scene = load("res://world_item.tscn")
	
	if item_scene == null:
		push_error("world_item.tscn not found")
		return

	var ground_items_node = get_tree().current_scene.get_node_or_null("GroundItems")
	if ground_items_node == null:
		push_error("GroundItems node not found in current scene")
		return

	for item_data in items_data:

		var item_instance = item_scene.instantiate()
		item_instance.item_name = item_data.get("item_name", "")
		item_instance.amount = item_data.get("amount", 1)

		ground_items_node.add_child(item_instance)

		item_instance.global_position = Vector2(
			item_data.get("x", 0.0),
			item_data.get("y", 0.0)
		)

func clear_dropped_items():
	for item in get_tree().get_nodes_in_group("world_items"):
		if is_instance_valid(item):
			item.queue_free()

func get_dropped_items_data() -> Array:
	var dropped_items: Array = []

	for item in get_tree().get_nodes_in_group("world_items"):
		if is_instance_valid(item):
			dropped_items.append(item.get_save_data())

	return dropped_items
