extends Node

@onready var player: CharacterBody2D = $"../player"
@onready var rect: ColorRect = $"../TimeUI/TimeFilter"

@onready var house_zone = $House
@onready var school_zone = $School
@onready var outside_zone = $Outside

const HOUSE_DAY_COLOR = Color("ffffff80")
const HOUSE_NIGHT_COLOR = Color("000000ff")
const SCHOOL_COLOR = Color(0.90, 0.97, 1.0, 0.08)
const OUTSIDE_DAY_COLOR = Color(1.001, 0.682, 0.638, 0.5)
const OUTSIDE_NIGHT_COLOR = Color(0.133, 0.0, 0.991, 0.807)

var current_zone
var target_color = HOUSE_DAY_COLOR



func update_color():
	if player != null:
		player.flags["col_correction_zone"] = current_zone
		if current_zone == "house":
			if player.flags["time_of_day"] == "morning":
				target_color = HOUSE_DAY_COLOR
			else:
				target_color = HOUSE_NIGHT_COLOR
		
		elif current_zone == "school":
			target_color = SCHOOL_COLOR
		
		elif current_zone == "outside":
			if player.flags["time_of_day"] == "morning":
				target_color = OUTSIDE_DAY_COLOR
			else:
				target_color = OUTSIDE_NIGHT_COLOR
		rect.color = target_color
		print("farba sa zmenila na")
		print(rect.color)
	else:
		print("color correction didnt find the player")


func _on_house_body_entered(body: Node2D) -> void:
	if body == player:
		current_zone = "house"
		update_color()

func _on_school_body_entered(body: Node2D) -> void:
	if body == player:
		current_zone = "school"
		update_color()


func _on_outside_body_entered(body: Node2D) -> void:
	if body == player:
		current_zone = "outside"
		update_color()
