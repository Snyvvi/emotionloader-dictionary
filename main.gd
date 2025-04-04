extends Node2D

const MOMO_DUMMY = preload("res://MomoDummy.tscn")

@onready var dummy_container: VBoxContainer = %DummyContainer



@onready var save_button: Button = %SaveButton
@onready var load_button: Button = %LoadButton
@onready var new_day_button: Button = %NewDayButton


@onready var add_momo: Button = %AddMomo


var momodummies:Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_rich("[color=aqua][b]Main._ready()")
	load_button.pressed.connect(_on_load_button_pressed)
	save_button.pressed.connect(_on_save_button_pressed)
	new_day_button.pressed.connect(_on_new_day_button_pressed)
	add_momo.pressed.connect(_on_add_momo_pressed)
	
	
	#ATTENTION Only relevant line here
	load_momos_frome_file() 	

	
func _on_load_button_pressed() -> void:
	load_momos_frome_file() 

func load_momos_frome_file() -> void:
	# load all data from file
	SaveLoader.load_game_data()
	setup_momos_from_file()
	
func setup_momos_from_file() -> void:
	print_rich("[color=aqua][b]Main.setup_momos_from_file()")
	momodummies = get_momodummies()
	# remove all momos so we can setup the ones from the savefile properly:
	for momodummy in momodummies:
		momodummy.queue_free()	
	# setup momos with emotions from dictionary in savefile
	for id in GlobalVariables.active_momo_dict:
		var momodummy = MOMO_DUMMY.instantiate()
		momodummy.random_momo_id = id
		momodummy.emotion = GlobalVariables.active_momo_dict[id]
		dummy_container.add_child(momodummy)
		momodummy.remove_button_pressed.connect(_on_momo_removed)
	
func setup_momos_from_new_emotions() -> void:
	print_rich("[color=aqua][b]Main.setup_momos_from_new_emotions()")
	momodummies = get_momodummies()
	for momodummie in momodummies:
		var emotion = GlobalVariables.get_next_available_emotion()
		if emotion != "":
			momodummie = momodummie as MomoDummy
			momodummie.load_emotion(emotion)		
		else:
			break
			
	#only for debug:
	GlobalVariables.print_variables()
	
func _on_save_button_pressed() -> void:
	GlobalVariables.active_momo_dict.clear()
	
	momodummies = get_momodummies()
	for momodummy in momodummies:
		momodummy = momodummy as MomoDummy
		GlobalVariables.active_momo_dict[momodummy.random_momo_id] = momodummy.emotion
	SaveLoader.save_game_data()
	get_tree().quit() 
	

func _on_new_day_button_pressed() -> void:
	print_rich("[color=aqua][b]New Day!")
	GlobalVariables.randomize_daily_emotions()
	setup_momos_from_new_emotions()


func _on_add_momo_pressed() -> void:
	add_new_momodummy() 
	
func add_new_momodummy() -> void:	
	print_rich("[color=aqua][b]Main.add_momodummy()")
	
	# dont add more momos if you have already 3 (max emotions)
	momodummies = get_momodummies()
	if momodummies.size() >= GlobalVariables.max_nr_emotions:
		print_rich("[color=red]No more space!")
		return
	
	# create new momo and set its id and emotion 
	var momodummy = MOMO_DUMMY.instantiate()
	momodummy.random_momo_id = hash(momodummy) #idk just some random big maybe unique integer
	var emotion = GlobalVariables.get_next_available_emotion()
	if emotion:
		momodummy.emotion = emotion
	dummy_container.add_child(momodummy)
	
	momodummy.remove_button_pressed.connect(_on_momo_removed)
	GlobalVariables.print_variables()
		
func get_momodummies() -> Array:
	return get_tree().get_nodes_in_group("MomoDummy")
	
func _on_momo_removed(momodummy:MomoDummy) -> void:
	GlobalVariables.add_available_emotion(momodummy.emotion)
	momodummy.queue_free()
