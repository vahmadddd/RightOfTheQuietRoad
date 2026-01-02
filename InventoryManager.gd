extends Node

# State of the backpack
var has_backpack: bool = false

# Stores dictionaries: [{"name": "Diary", "thumb": resource}, ...]
var backpack: Array = []

# This is the function your InteractableItem was looking for!
func collect_backpack():
	has_backpack = true
	print("Backpack acquired!")

# Adds the data package (name and thumbnail)
func add_item(item_data: Dictionary):
	if has_backpack:
		backpack.append(item_data)
		print("Added to bag: ", item_data.name)
	else:
		print("Error: Tried to add item without a backpack!")

# Removes an item by searching for its name string
func remove_item(item_name: String):
	for i in range(backpack.size()):
		if backpack[i].name == item_name:
			backpack.remove_at(i)
			print("Removed: ", item_name)
			return

# Checks if an item exists by name (for locks/doors)
func has_item(item_name: String) -> bool:
	for item in backpack:
		if item.name == item_name:
			return true
	return false
