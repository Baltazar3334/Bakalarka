extends CharacterBody2D
class_name EntityBase

@export var entity_id: String = ""
@export var display_name: String = ""
@export var can_interact: bool = true

func interact(interactor):
	print(display_name + " interacted with by " + str(interactor.name))


func set_can_interact(value: bool):
	can_interact = value
