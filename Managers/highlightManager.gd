extends Node

var highlighted := {}

func highlight(node: Node, duration := -1.0):

	if node == null:
		return

	var sprite = find_canvas_item(node)

	if sprite == null:
		push_warning("No Sprite2D/AnimatedSprite2D found in " + node.name)
		return

	if highlighted.has(node):
		return

	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(sprite, "modulate", Color(1.5,1.5,0.5), 0.35)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.35)

	highlighted[node] = tween

	if duration > 0:
		await get_tree().create_timer(duration).timeout
		stop_highlight(node)


func stop_highlight(node: Node):

	if !highlighted.has(node):
		return

	var sprite = find_canvas_item(node)

	if sprite:
		sprite.modulate = Color.WHITE

	highlighted[node].kill()
	highlighted.erase(node)


func find_canvas_item(node: Node):

	if node is CanvasItem:
		return node

	for child in node.get_children():
		var result = find_canvas_item(child)
		if result:
			return result

	return null
