extends CharacterBody2D
class_name EntityBase

@onready var anim = $AnimatedSprite2D

@export var entity_id: String = ""
@export var display_name: String = ""
@export var can_interact: bool = true
@export var idleAnimation: String = "idle"

var is_moving = false
var target_position
var move_speed = 100
var looking_up = false

signal move_finished

func _ready():
	anim.play(idleAnimation)

func interact(interactor):
	print(display_name + " interacted with by " + str(interactor.name))


func set_can_interact(value: bool):
	can_interact = value


func move_to(pos: Vector2, speed: int):
	target_position = pos
	move_speed = speed
	is_moving = true

func update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		if looking_up:
			anim.play("lookUp")
			return
		anim.play("idle")
		return

	if direction.y < 0:
		anim.play("walkUp")
	else:
		anim.play("walkDown")


func _physics_process(delta):
	if is_moving:
		var direction = (target_position - global_position)
		
		update_animation(direction.normalized())
		
		if direction.length() < 2:
			global_position = target_position
			is_moving = false
			velocity = Vector2.ZERO
			update_animation(Vector2.ZERO)
			move_finished.emit()
			print(entity_id)
			print("sa zastavil")
			return
		
		velocity = direction.normalized() * move_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		update_animation(Vector2.ZERO)
