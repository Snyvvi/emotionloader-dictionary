class_name MomoDummy extends HBoxContainer
@onready var emotion_label: Label = $EmotionLabel
@onready var id_label: Label = $IDLabel
@onready var remove_button: Button = $RemoveButton

# only for visuals/debug
signal remove_button_pressed

var random_momo_id:int:set = _set_id
var emotion:String:set = _set_emotion

#ATTENTION actual relevant function
func load_emotion(_emotion:String) -> void:
	emotion = _emotion
	print_rich("[color=aqua]MomoDummy.load_emotion(): [/color]", emotion)

func _ready() -> void:
	remove_button.pressed.connect(func(): remove_button_pressed.emit(self))
	_set_id(random_momo_id) 
	_set_emotion(emotion)
	
# setter and getter (not really relevant)	
# only for visuals/debug		
func _set_id(value) -> void:
	random_momo_id = value	
	if is_node_ready():
		id_label.text = "ID: " + str(random_momo_id)

func _set_emotion(value) -> void:
	emotion = value
	if is_node_ready():
		emotion_label.text = emotion
