extends EntityNPC

var player_near := false
var in_dialog := false
var wake_until := 0

func _ready():
	var dialog_ui = get_node("../../DialogUI/TextureRect")
	dialog_ui.dialog_closed.connect(_on_dialog_closed)
	super._ready()


func interact(interactor):
	in_dialog = true
	super.interact(interactor)


func update_animation(direction: Vector2):
	if in_dialog:
		if player.flags["cat_gave_treat"] == 1:
			anim.play("happy")
		else:
			anim.play("wake")
		return
	if player_near and Time.get_ticks_msec() < wake_until:
		if player.flags["cat_gave_treat"] == 1:
			anim.play("happy")
		else:
			anim.play("wake")
		return
	anim.play("idle")

func _on_dialog_closed():
	in_dialog = false
	if player_near:
		wake_until = Time.get_ticks_msec() + 3000

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body != player:
		return
	player_near = true
	wake_until = Time.get_ticks_msec() + 3000

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body != player:
		return
	player_near = false
	wake_until = 0
