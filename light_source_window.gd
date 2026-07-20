extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var spriteWindowNight: Sprite2D = $SpriteWindowNight
@onready var light: PointLight2D = $PointLight2D
@onready var player = get_tree().current_scene.get_node_or_null("player")

var activation_distance = 600.0

func _process(_delta):
	if player == null:
		return
	if player.flags["time_of_day"] == "morning":
		await get_tree().create_timer(0.9).timeout
		if spriteWindowNight != null:
			spriteWindowNight.visible = false
		sprite.modulate = Color(1, 1, 1, 1)
		light.enabled = global_position.distance_to(player.global_position) < activation_distance
		sprite.visible = global_position.distance_to(player.global_position) < activation_distance
	else:
		if spriteWindowNight != null:
			spriteWindowNight.visible = true
		sprite.modulate = Color(0.235, 0.223, 1.0, 1.0)
		light.color = Color(0.4, 0.482, 0.947, 1.0)
		await get_tree().create_timer(0.9).timeout

func set_light_enabled(enabled: bool):
	light.visible = enabled
