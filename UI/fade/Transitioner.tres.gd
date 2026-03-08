extends Control

class_name Transitioner

@onready var animation_tex : TextureRect = $TextureRect
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_tex.visible = false

func set_next_animation(fading_out : bool):
	if (fading_out):
		animation_player.queue("fade_out")
	else:
		animation_player.queue("fade_in")
