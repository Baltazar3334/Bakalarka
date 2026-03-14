extends CanvasLayer


@onready var animation_tex : TextureRect = $TransitionerControl/TextureRect
@onready var animation_player : AnimationPlayer = $TransitionerControl/AnimationPlayer

func _ready() -> void:
	animation_tex.visible = false

func set_next_animation(fading_out : bool):
	if (fading_out):
		animation_player.queue("fade_out")
	else:
		animation_player.queue("fade_in")

func change_scene(path):
	animation_player.queue("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	animation_player.queue("fade_in")
