extends Node2D

@onready var light: PointLight2D = $PointLight2D
@onready var player = get_tree().current_scene.get_node_or_null("player")

var activation_distance = 500.0

func _process(_delta):
	if player == null:
		return
	if player.flags["time_of_day"] == "afternoon":
		light.enabled = global_position.distance_to(player.global_position) < activation_distance

func set_light_enabled(enabled: bool):
	light.enabled = enabled
