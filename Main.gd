extends Node2D

func _ready():
	# 1. Teleport Derek to the SpawnPoint immediately
	if has_node("SpawnPoint") and has_node("Derek"):
		$Derek.global_position = $SpawnPoint.global_position
	
	# 2. Find the FadeOverlay and fade it out (Fade In effect)
	var fade = get_tree().get_root().find_child("FadeOverlay", true, false)
	if fade:
		fade.modulate.a = 1.0 # Start fully black
		var tween = create_tween()
		tween.tween_property(fade, "modulate:a", 0.0, 0.5) # Transition to transparent

func setup_player_position():
	# Check if both nodes exist to avoid errors
	if has_node("Derek") and has_node("SpawnPoint"):
		$Derek.global_position = $SpawnPoint.global_position
	else:
		print("Warning: Derek or SpawnPoint missing from Main scene.")

func handle_fade_in():
	# Look for the FadeOverlay in the UI CanvasLayer
	# true, false means "search sub-children" and "don't care about internal nodes"
	var fade = find_child("FadeOverlay", true, false)
	
	if fade:
		# Start fully black
		fade.modulate.a = 1.0
		
		# Smoothly transition alpha to 0 (transparent) over 0.8 seconds
		var tween = create_tween()
		tween.tween_property(fade, "modulate:a", 0.0, 0.8).set_trans(Tween.TRANS_SINE)
