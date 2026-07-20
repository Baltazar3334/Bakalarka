extends CanvasLayer

enum TransitionType {
	CUSTOM,
	SIMPLE
}

@onready var animation_tex : TextureRect = $TransitionerControl/TextureRect
@onready var animation_player : AnimationPlayer = $TransitionerControl/AnimationPlayer

func _ready() -> void:
	print("transitioner na layer: ", layer)
	animation_tex.visible = false
	var color_rect = $TransitionerControl/ColorRect
	color_rect.modulate.a = 0.0
	
	$TransitionerControl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$TransitionerControl/ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$TransitionerControl/TextureRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	

func set_next_animation(fading_out : bool, transition_type: TransitionType = TransitionType.CUSTOM):
	animation_player.queue(get_animation_name(fading_out,transition_type))

func change_scene(path: String,transition_type: TransitionType = TransitionType.CUSTOM,duration: float = -1.0):
	var anim_name = get_animation_name(true,transition_type)

	if duration > 0:
		print(anim_name)
		var anim_length = animation_player.get_animation(anim_name).length
		animation_player.speed_scale = anim_length / duration
	else:
		animation_player.speed_scale = 1.0

	animation_player.play(anim_name)

	await animation_player.animation_finished

	get_tree().change_scene_to_file(path)

	animation_player.play(get_animation_name(false,transition_type))


func get_animation_name(fade_out: bool,transition_type: TransitionType) -> String:
	match transition_type:
		TransitionType.SIMPLE:
			return "fade_out_simple" if fade_out else "fade_in_simle"
		TransitionType.CUSTOM:
			return "fade_out" if fade_out else "fade_in"
	return ""
