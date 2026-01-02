extends Area2D

# This allows you to type the message directly in the Godot Inspector!
@export_multiline var interact_message: String = "Hello there."
@export var is_dialogue: bool = true

func interact():
	if is_dialogue:
		print("Derek sees: ", interact_message)
		# Later, we will tell the Dialogue Box to show this string
