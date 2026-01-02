extends Area2D

# We define the three behaviors you requested
enum Type { EXAMINE, PICK_UP, USE_REQUIRED }

@export_group("Item Settings")
@export var item_type: Type = Type.EXAMINE
@export var item_name: String = "Object"
@export var item_thumbnail: Texture2D # For the inventory UI
@export var dialogue_text: Array[String] = ["It's just an ordinary object."]

@export_group("Lock Settings")
@export var required_item: String = "" # Name of item needed to 'unlock' this

func _ready():
	# Set to Layer 2 so the player's RayCast/Area can find it
	collision_layer = 2 
	collision_mask = 0

func interact():
	match item_type:
		Type.EXAMINE:
			# Just show the first line of text
			GameEvents.request_dialogue.emit(dialogue_text[0])
			
		Type.PICK_UP:
			_handle_pickup()
			
		Type.USE_REQUIRED:
			_handle_use()

func _handle_pickup():
	# Special case: The bag itself
	if item_name == "Backpack":
		Inventory.collect_backpack()
		GameEvents.request_dialogue.emit("Got my backpack. Now I can carry things.")
		queue_free()
		return
	
	# Normal items
	if Inventory.has_backpack:
		var data = {
			"name": item_name,
			"thumb": item_thumbnail
		}
		Inventory.add_item(data)
		GameEvents.request_dialogue.emit("Picked up " + item_name + ".")
		queue_free()
	else:
		GameEvents.request_dialogue.emit("I can't carry this. I don't have a backpack.")

func _handle_use():
	if Inventory.has_item(required_item):
		GameEvents.request_dialogue.emit("Used " + required_item + " on the " + item_name + "!")
		# Trigger your door opening or event here
	else:
		GameEvents.request_dialogue.emit("It's locked. I might need a " + required_item + ".")
