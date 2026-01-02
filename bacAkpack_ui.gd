extends TextureButton

func _on_bag_clicked():
	# 1. Find the CanvasLayer named InventoryUI
	var inv_layer = get_tree().get_root().find_child("CanvasLayer", true, false)
	
	if inv_layer:
		# 2. Check if the function exists on the layer itself
		if inv_layer.has_method("toggle_inventory"):
			inv_layer.toggle_inventory()
		# 3. If not, check if it's on a child node (like a Background or Control node)
		else:
			for child in inv_layer.get_children():
				if child.has_method("toggle_inventory"):
					child.toggle_inventory()
					return
	else:
		print("Error: Could not find node named 'InventoryUI'")
