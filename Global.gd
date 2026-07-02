extends Node

var permission_level := 0
var permission_just_raised = false



const DEFAULT_FLAGS := {
	"neighbor_story": 0,
	"neighbor_visit_story": 0,
	"neighbor_opinion": 0,
	"neighbor_gave_money": 0,
	"neighbor_asked_about_son": 0,
	"neighbor_there": 1,
	"neighbor_asking_for_medicine": 0,
	
	"factory_introduced": 0,
	"factory_work_started": 0,
	"factory_items_return": 0,
	"factory_successful_boxes": 0,
	
	"david_opinion": 0,
	"david_story": 0,
	"david_cinema_visit_planned": 0,
	"david_cinema_tonight": 0,
	
	"parents_at_home": 1,
	"father_story": 0,
	"father_greeted": 0,
	"father_there": 1,
	"father_caught_cigarets": 0,
	"father_told_about_post_office": 0,
	
	"took_cigarets_from_campfire": 0,
	
	"med_lady_friendly": 0,
	"med_lady_story": 0,
	
	"day_of_the_week": 1,
	"money_6_taken": 0,
	"money_5_taken": 0,
	"time_of_day": "morning",
	
	"permission_level": 0,
}


func _ready():
	load_global_data()



func load_global_data():
	permission_level = MenuFileManager.get_global_value("permission_level", 0)

func set_permission_level(level:int):
	permission_level = level
	MenuFileManager.set_global_value("permission_level",level)
