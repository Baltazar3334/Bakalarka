extends Node

signal inventory_changed

var inventory = {
	"hands": {},
	"pockets": {},
	"backpack": {}
}

#nacitanie z dat SaveManageru
func set_loaded_inventory(data: Dictionary) -> void:
	inventory.clear()
	for container_name in data.keys():
		inventory[container_name] = data[container_name]
	inventory_changed.emit()
	print("Loaded inventory: ", inventory)

#spravovanie inventaru
func add_item(item_name: String, amount: int = 1):
	var container = inventory["hands"]
	if container.has(item_name):
		container[item_name] += amount
	else:
		container[item_name] = amount
		
	emit_signal("inventory_changed")
	print_inventory()

func remove_item(item_name: String, amount: int = 1):
	var container
	for container_name in inventory:
		container = inventory[container_name]
		if container.has(item_name):
			container[item_name] -= amount
			if container[item_name] <= 0:
				container.erase(item_name)
	
	emit_signal("inventory_changed")
	print_inventory()

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

func print_inventory():
	print("----- INVENTORY -----")
	for container_name in inventory:
		print(container_name + ":")
		for item in inventory[container_name]:
			print(" ", item, ":", inventory[container_name][item])
