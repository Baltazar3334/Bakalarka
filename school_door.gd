extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var collisionBox = $"Area2D/CollisionShape2D" 
@onready var dialog_ui = get_node("../../DialogUI/TextureRect")
@onready var player = get_tree().current_scene.get_node_or_null("player")

func _ready() -> void:
	pass


func highlightDoor():
	HighlightManager.highlight(self, -1)
	
func stopHighlightDoor():
	HighlightManager.stop_highlight(self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != player:
		return
	if player.flags["school_completed"] == 0:
		highlightDoor()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != player:
		return
	if player.flags["school_completed"] == 0:
		stopHighlightDoor()




func _on_school_classroom_detection_zone_body_entered(body: Node2D) -> void:
	if body != player:
		return
	if player.flags["school_first_day"] == 1:
		dialog_ui.open_dialog("school_introduction")
		player.flags["school_first_day"] = 0
