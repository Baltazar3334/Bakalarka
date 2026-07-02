extends Node

signal inventory_changed

var inventory = {
	"hands": {},
	"pockets": {},
	"backpack": {},
	"carry": {}
}

#LOAD DATA FROM SAVEMANAGER
func set_loaded_inventory(data: Dictionary) -> void:
	inventory.clear()
	for container_name in data.keys():
		inventory[container_name] = data[container_name]
	inventory_changed.emit()
	print("Loaded inventory: ", inventory)

#INTERACTIONS WITH INVENTORY
func add_item(item_name: String, amount: int = 1):
	var container = inventory["hands"]
	if container.has(item_name):
		container[item_name] += amount
	else:
		container[item_name] = amount
		
	emit_signal("inventory_changed")


#ADDING ITEM TO CARRY CONTAINER
func add_carry_item(item_name: String):

	if not inventory["carry"].is_empty():
		print("Already carrying something")
		return false

	inventory["carry"][item_name] = 1

	inventory_changed.emit()

	return true

func remove_item(item_name: String, amount: int = 1):

	for container_name in inventory.keys():

		var container = inventory[container_name]

		if not container.has(item_name):
			continue

		container[item_name] -= amount

		if container[item_name] <= 0:
			container.erase(item_name)

		inventory_changed.emit()
		return

	print("Item not found:", item_name)



func container_index_for_item(item_name: String) -> int:
	for i in range(inventory.size()):
		if inventory.keys()[i] == item_name:
			return i
	return -1

func has_item(item_name: String, amount: int = 1) -> bool:
	var total = 0
	for container_name in inventory:
		var container = inventory[container_name]
		if container.has(item_name):
			total += container[item_name]
	return total >= amount

func move_item(item_name: String, from_container: String, to_container: String, amount: int = 1 ):
	if not inventory.has(from_container) or not inventory.has(to_container):
		print("nonexistent container in moving action")
		return
		
	var from = inventory[from_container]
	var to = inventory[to_container]
	
	if not from.has(item_name):
		print("container does not contain item:", from_container)
		return
		
	from[item_name] -= amount
	if from[item_name] <= 0:
		from.erase(item_name)

	if to.has(item_name):
		to[item_name] += amount
	else:
		to[item_name] = amount

	print("moved", item_name, "from", from_container, "to", to_container)
	emit_signal("inventory_changed")
	print_inventory()

func get_container_items(container_name: String) -> Array:
	if not inventory.has(container_name):
		print("container doesnt exist in get_container_items")
		return []
	return inventory[container_name].keys()

func is_item_in_container(item_name: String, container_name: String) -> bool:
	if not inventory.has(container_name):
		print("Container does not exist:", container_name)
		return false

	if not has_item(item_name):
		print("Item not found in inventory:", item_name)
		return false

	var container = inventory[container_name]

	if container.has(item_name):
		return true

	return false



func print_inventory():
	print("----- INVENTORY -----")
	for container_name in inventory:
		print(container_name + ":")
		for item in inventory[container_name]:
			print(" ", item, ":", inventory[container_name][item])
