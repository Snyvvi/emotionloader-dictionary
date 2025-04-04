extends Node

func load_game_data() -> void:
	var savestate:SaveState = SaveState.load_data()
	
	GlobalVariables.is_morning = savestate.is_morning 
	GlobalVariables.daily_status_dict = savestate.daily_status_dict
	GlobalVariables.active_momo_dict = savestate.active_momo_dict
	
	# only for debugging
	GlobalVariables.print_variables()
	
	if GlobalVariables.daily_status_dict.is_empty():
		print_rich("[color=magenta]randomize to get first values[/color] ")
		GlobalVariables.randomize_daily_emotions()
	
func save_game_data() -> void:
	var savestate:SaveState = SaveState.new()
	
	savestate.is_morning = GlobalVariables.is_morning
	savestate.daily_status_dict = GlobalVariables.daily_status_dict
	savestate.active_momo_dict = GlobalVariables.active_momo_dict
	
	# only for debugging
	GlobalVariables.print_variables()
	
	savestate.save_data()
