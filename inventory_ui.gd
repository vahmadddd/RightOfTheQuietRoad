extends CanvasLayer

@onready var grid = $Background/GridContainer
@onready var background = $Background

func _ready():
	background.visible = false 

func _input(event):
	if event.is_action_pressed("inventory"):
		toggle_inventory()

func toggle_inventory():
	background.visible = !background.visible
	if background.visible:
		refresh_slots()

func refresh_slots():
	for child in grid.get_children():
		child.queue_free()
		
	for item_name in Inventory.backpack:
		var slot = VBoxContainer.new()
		slot.custom_minimum_size = Vector2(120, 150)
		slot.alignment = BoxContainer.ALIGNMENT_CENTER
		
		# --- DYNAMIC THUMBNAIL LOGIC ---
		var thumb = TextureRect.new()
		thumb.custom_minimum_size = Vector2(64, 64)
		thumb.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		thumb.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		# 1. Try to find the item in the room to steal its sprite
		var world_item = get_tree().get_root().find_child(item_name, true, false)
		
		if world_item and world_item.has_node("Sprite2D"):
			thumb.texture = world_item.get_node("Sprite2D").texture
		else:
			# 2. Fallback: Look for a PNG file in assets
			var img_path = "res://assets/items/" + item_name.to_lower() + ".png"
			if FileAccess.file_exists(img_path):
				thumb.texture = load(img_path)
			else:
				# 3. Last resort: Godot Icon
				thumb.texture = load("res://icon.svg") 
		
		# --- NAME & BUTTONS ---
		var name_label = Label.new()
		name_label.text = item_name
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var use_btn = Button.new()
		use_btn.text = "Use"
		use_btn.pressed.connect(_on_use_pressed.bind(item_name))
		
		var throw_btn = Button.new()
		throw_btn.text = "Throw"
		throw_btn.pressed.connect(_on_throw_pressed.bind(item_name))
		
		slot.add_child(thumb)
		slot.add_child(name_label)
		slot.add_child(use_btn)
		slot.add_child(throw_btn)
		grid.add_child(slot)

func _on_use_pressed(item_name):
	match item_name:
		"Diary":
			GameEvents.emit_signal("display_dialogue", ["I shouldn't read this right now. It's too painful."])
		"Key":
			GameEvents.emit_signal("display_dialogue", ["I need to find the door this belongs to."])
	background.visible = false 

func _on_throw_pressed(item_name):
	Inventory.remove_item(item_name)
	refresh_slots()
