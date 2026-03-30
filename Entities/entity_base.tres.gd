extends CharacterBody2D
class_name EntityBase

@export var entity_id: String = ""
@export var display_name: String = ""
@export var can_interact: bool = true

var is_moving = false
var target_position
var move_speed = 100

signal move_finished

func interact(interactor):
	print(display_name + " interacted with by " + str(interactor.name))


func set_can_interact(value: bool):
	can_interact = value


func move_to(pos: Vector2, speed: int):
	target_position = pos
	move_speed = speed
	is_moving = true

func _physics_process(delta):
	if is_moving:
		var direction = (target_position - global_position)
		
		if direction.length() < 2:
			global_position = target_position
			is_moving = false
			velocity = Vector2.ZERO
			move_finished.emit()
			return
		
		velocity = direction.normalized() * move_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
