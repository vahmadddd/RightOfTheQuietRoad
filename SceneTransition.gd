extends Area2D

@export var target_scene: PackedScene

func interact():
	if target_scene:
		play_transition()
	else:
		print("Door Error: No target scene assigned! Check the Inspector.")

func play_transition():
	# 1. Find the FadeOverlay in your UI
	var fade = get_tree().get_root().find_child("FadeOverlay", true, false)
	
	if fade:
		var tween = create_tween()
		# Fade to black over 0.5 seconds
		tween.tween_property(fade, "modulate:a", 1.0, 0.5)
		# Wait for fade to finish, then swap scenes
		tween.finished.connect(func(): get_tree().change_scene_to_packed(target_scene))
	else:
		# If no fade UI is found, just teleport immediately
		get_tree().change_scene_to_packed(target_scene)
