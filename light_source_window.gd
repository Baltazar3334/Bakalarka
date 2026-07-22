extends Node2D

@onready var light: PointLight2D = $PointLight2D
@onready var lightSoft: PointLight2D = $PointLight2DSoft
@onready var occluderSoft: LightOccluder2D = $LightOccluder2D
@onready var spriteWindowNight: Sprite2D
@onready var player = get_tree().current_scene.get_node_or_null("player")

var activation_distance = 600.0

func _ready():
	spriteWindowNight = get_node_or_null("SpriteWindowNight")

func _process(_delta):
	if player == null:
		return
	if player.flags["time_of_day"] == "morning":
		await get_tree().create_timer(0.9).timeout
		light.color = Color(0.637, 0.51, 0.306, 1.0)
		light.enabled = global_position.distance_to(player.global_position) < activation_distance
		lightSoft.enabled = global_position.distance_to(player.global_position) < activation_distance
		occluderSoft.visible = global_position.distance_to(player.global_position) < activation_distance
		if spriteWindowNight != null:
			spriteWindowNight.visible = false
	else:
		await get_tree().create_timer(0.9).timeout
		light.color = Color(0.4, 0.482, 0.947, 1.0)
		lightSoft.enabled = false
		occluderSoft.visible = false
		if spriteWindowNight != null:
			spriteWindowNight.visible = true

func set_light_enabled(enabled: bool):
	light.visible = enabled
