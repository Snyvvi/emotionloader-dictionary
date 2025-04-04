extends Node


var use_dict:bool = false

var max_nr_emotions:int = 3
var is_morning:bool = true

var status:Array[String] = ["hurt", "neglected", "sick", "bored", "eepy", "unkept", "sad", "stinky"]

# key: emotion, value: is_emotion_used
var daily_status_dict:Dictionary[String,bool] = {}

# key: id of momo, value: emotion
var active_momo_dict:Dictionary[int,String]


func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	
	# only for debugging
	print_rich("[color=magenta][b]GlobalVariables._ready()[/b][/color] ")
	print_variables()
	
func randomize_daily_emotions() -> void:
	var randomized_status = status.duplicate()
	randomized_status.shuffle()
	var daily_status = randomized_status.slice(0,max_nr_emotions)	# get the first three(max_nr_emotions) emotions of the shuffled array
	daily_status_dict.clear()
	for status in daily_status:
		daily_status_dict[status] = false
	
	# only for debugging
	print_rich("[color=magenta]GlobalVariables.randomize_emotions()[/color] ")
	print_variables()

func get_next_available_emotion() -> String:	
	for emotion in daily_status_dict:
		if not daily_status_dict[emotion]:
			daily_status_dict[emotion] = true
			return emotion
	return ""		

func add_available_emotion(emotion:String) -> void:
	daily_status_dict[emotion] = false
	
# only for debugging
func print_variables() -> void:
	printt("is_morning: ", is_morning)
	printt("status: ", status)
	printt("daily_status_dict: ", daily_status_dict)
	printt("(only changed when saved/loaded)  available_momo_dict:", active_momo_dict)
