extends Node

func refresh_all_entities():
	var entities = get_tree().get_nodes_in_group("entities")
	
	for entity in entities:
		if entity.has_method("refresh_availability"):
			print("entita sa refreshla:" + entity.entity_id)
			entity.refresh_availability()
