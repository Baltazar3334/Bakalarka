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
		"inventory": InventoryManager.inventory
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
	return data

func save_exists(slot:int) -> bool:
	return FileAccess.file_exists(SAVE_PATH + str(slot) + ".save")


func load_game_to_scene(slot:int, scene_path:String="res://main.tscn") -> void:
	if not save_exists(slot):
		print("Save not found for slot ", slot)
		return 

	current_save_slot = slot
	loaded_data = load_game(slot)
	
	if loaded_data.has("inventory"):
		InventoryManager.set_loaded_inventory(loaded_data["inventory"])
	Transitioner.change_scene(scene_path)


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
