extends Node2D

@onready var light: Sprite2D = $Sprite2D
@onready var player = get_tree().current_scene.get_node_or_null("player")

var activation_distance = 600.0

func _process(_delta):
	if player == null:
		return
	if player.flags["time_of_day"] == "afternoon":
		light.visible = global_position.distance_to(player.global_position) < activation_distance

func set_light_enabled(enabled: bool):
	light.visible = enabled
