extends Node2D

@onready var light: PointLight2D = $PointLight2D
@onready var player = get_tree().current_scene.get_node_or_null("player")

var activation_distance = 600.0

func _process(_delta):
	if player == null:
		print("player is null on one of the light sources")
		return
	if player.flags["time_of_day"] == "morning":
		await get_tree().create_timer(0.9).timeout
		light.enabled = global_position.distance_to(player.global_position) < activation_distance
	else:
		await get_tree().create_timer(0.9).timeout
		light.enabled = false

func set_light_enabled(enabled: bool):
	light.visible = enabled
