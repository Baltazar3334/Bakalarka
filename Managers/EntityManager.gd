extends Node



func refresh_all_entities():
	var entities = get_tree().get_nodes_in_group("entities")
	for entity in entities:
		if entity.has_method("refresh_availability"):
			print("entita sa refreshla:" + entity.entity_id)
			entity.refresh_availability()

func get_entity(entityId: String):
	var entities = get_tree().get_nodes_in_group("entities")
	for entity in entities:
		if entity.entity_id == entityId:
			return entity
	print("entity not found: get_entity")
	return null

func get_marker(marker_name: String):
	for marker in get_tree().get_nodes_in_group("npc_markers"):
		if marker.name == marker_name:
			return marker
	print("Marker not found: " + marker_name)
	return null

func move_entities(data: Array):
	for npc_data in data:
		var entity = get_entity(npc_data["id"])
		if entity == null:
			continue

		var tilemap = get_tree().current_scene.get_node("LayerCollision")
		var cell = Vector2i(npc_data["x"], npc_data["y"])
		var target_pos = tilemap.to_global(tilemap.map_to_local(cell))
		entity.move_to(target_pos, npc_data.get("speed", 100))
		
