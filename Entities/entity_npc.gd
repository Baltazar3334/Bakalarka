extends EntityBase
class_name EntityNPC

@export var dialog_key: String = ""
@onready var player = $"../../player"
@onready var collisionShape = $CollisionShape2D


@export var required_flags = {
}

@export var required_items = {
}



func _ready():
	add_to_group("entities")
	refresh_availability()

func interact(interactor):
	print("ENTITY dialog_key =", dialog_key)
	if not can_interact:
		print("cant interact")
		return
	if dialog_key.is_empty():
		push_warning("NPC has no dialog_key assigned.")
		return
	
	var dialog_ui = get_node("../../DialogUI/TextureRect")
	if dialog_ui == null:
		push_warning("DialogUI node not found in current scene.")
		return
	
	dialog_ui.open_dialog(dialog_key)

func refresh_availability():
	if meets_requirements():
		enable()
	else:
		disable()

func meets_requirements() -> bool:
	if not check_flag_requirements():
		return false
	if not check_item_requirements():
		return false
	return true

func check_flag_requirements() -> bool:
	if required_flags == null:
		return true
	
	for flag_name in required_flags.keys():
		var required_value = required_flags[flag_name]
		var current_value = player.flags.get(flag_name)
		if current_value != required_value:
			return false
	return true

func check_item_requirements() -> bool:
	if required_items == null:
		return true
		
	for item_name in required_items.keys():
		var required_amount = int(required_items[item_name])
		
		if not InventoryManager.has_item(item_name, required_amount):
			return false
	
	return true

func enable():
	visible = true
	set_can_interact(true)
	collisionShape.disabled = false

func disable():
	visible = false
	set_can_interact(false)
	collisionShape.disabled = true
