extends Node2D

@onready var light: PointLight2D = $PointLight2D
@onready var player = get_tree().current_scene.get_node_or_null("player")

var activation_distance = 500.0

func _process(_delta):
	if player == null:
		return
	if player.flags["time_of_day"] == "afternoon":
		await get_tree().create_timer(0.9).timeout
		light.enabled = global_position.distance_to(player.global_position) < activation_distance
		

func set_light_enabled(enabled: bool):
	light.enabled = enabled


func _on_light_disable_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and player.flags["time_of_day"] == "afternoon":
		body.enter_light()


func _on_light_disable_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and player.flags["time_of_day"] == "afternoon":
		body.exit_light()
