extends Node

var permission_level := 0
var permission_just_raised = false

signal player_config_changed
signal post_office_config_changed

var post_office_salary := 1:
	set(value):
		post_office_salary = value
		post_office_config_changed.emit()

var post_office_work_days := 7:
	set(value):
		post_office_work_days = value
		post_office_config_changed.emit()

var player_max_speed = 150:
	set(value):
		player_max_speed = value
		player_config_changed.emit()

var school_days = 5:
	set(value):
		school_days = value
		player_config_changed.emit()

var recap_tribute = 5:
	set(value):
		recap_tribute = value
		player_config_changed.emit()

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
	"factory_successful_boxes_multiplier": 1,
	
	"david_opinion": 0,
	"david_story": 0,
	"david_cinema_visit_planned": 0,
	"david_cinema_tonight": 0,
	"david_there_evening": 1,
	"david_school_messed_up": 0,
	"david_woke_up_from_meds": 0,
	
	"parents_at_home": 1,
	"father_story": 0,
	"father_greeted": 0,
	"father_there": 1,
	"father_caught_cigarets": 0,
	"father_told_about_post_office": 0,
	
	"cat_introduction": 0,
	"cat_hint_key": 0,
	"cat_helped_jessie": 0,
	"cat_gave_treat": 0,
	
	"took_cigarets_from_campfire": 0,
	
	"med_lady_friendly": 0,
	"med_lady_story": 0,
	
	"day_of_the_week": 1,
	"time_of_day": "morning",
	
	"money_6_taken": 0,
	"money_5_taken": 0,
	
	"school_completed": 0,
	"school_first_day": 1,
	"school_days": 5,
	"recap_tribute": 0,
	
	"candy_meeting": 0,
	"boniface_expelled": 0,
	"jake_recapped": 0,
	"jake_intro": 0,
	"jake_cinema_planned": 0,
	"jake_know_secret": 1,
	"jake_borrow_possible": 0,
	"jake_borrowed_money": 0,
	"jake_borrowed_for_david": 0,
	"jake_how_much_knows": 0,
	
	"post_office_work_days": 5,
	
	
	"permission_level": 0,
}


func _ready():
	load_global_data()
	post_office_config_changed.emit()
	player_config_changed.emit()
	ConfigManager.load_all_configs()
	print("Updated config values")

func load_global_data():
	permission_level = MenuFileManager.get_global_value("permission_level", 0)

func set_permission_level(level:int):
	permission_level = level
	MenuFileManager.set_global_value("permission_level",level)
