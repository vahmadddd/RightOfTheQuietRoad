extends Panel

@onready var text_label = $TextDisplay
var is_active: bool = false
var can_close: bool = false

func _ready():
	# Connect the signal to the local function
	GameEvents.request_dialogue.connect(show_message)
	visible = false

func show_message(new_text: String):
	if is_active: return 
	
	visible = true
	is_active = true
	can_close = false
	text_label.text = new_text
	
	# Typewriter effect
	text_label.visible_ratio = 0
	var tween = create_tween()
	tween.tween_property(text_label, "visible_ratio", 1.0, 1.0)
	
	await get_tree().create_timer(0.2).timeout
	can_close = true

func _input(event):
	if is_active and can_close and event.is_action_pressed("interact"):
		close_dialogue()

func close_dialogue():
	visible = false
	is_active = false
	can_close = false
	get_viewport().set_input_as_handled()
