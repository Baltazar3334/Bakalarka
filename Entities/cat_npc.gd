extends EntityNPC

var player_near := false
var leave_timer_running := false

@onready var detection_area = $DetectionArea


func _ready():
	super._ready()


func update_animation(direction: Vector2):
	pass

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body != player:
		return
	player_near = true
	anim.play("wake")


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body != player:
		return
	player_near = false
	await get_tree().create_timer(3.0).timeout
	anim.play("idle")
	
