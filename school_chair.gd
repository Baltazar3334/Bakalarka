extends Node2D

@onready var collisionBox = $"Area2D/CollisionShape2D" 
@onready var dialog_ui = get_node("../../DialogUI/TextureRect")
@onready var player = get_tree().current_scene.get_node_or_null("player")


func _ready() -> void:
	pass

func interact(interactor):
	if dialog_ui.is_open:
		return
	if !interactor.is_sitting: 
		interactor.is_sitting = true
		interactor.can_move = false
		interactor.global_position = self.global_position
		interactor.anim.play("idleLookingUp")
		dialog_ui.open_dialog("school_start_cond")
	else:
		interactor.is_sitting = false
		interactor.can_move = true
		interactor.global_position = self.global_position + Vector2(-8, 0)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != player:
		return
	player.register_interactable(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != player:
		return
	player.unregister_interactable(self)
