extends CharacterBody2D

const WALK_SPEED = 200.0
const RUN_SPEED = 400.0  
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D
@onready var prompt = $InteractionPrompt
@onready var interaction_area = $Interactions

var current_interactable = null

func _input(event):
	# If E is pressed and we are near something interactable
	if event.is_action_pressed("interact") and current_interactable:
		if current_interactable.has_method("interact"):
			current_interactable.interact()

func _physics_process(delta):
	# 1. Add Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# 2. Stop movement if a DialogueBox is open
	var db = get_tree().get_root().find_child("DialogueBox", true, false)
	if db and db.visible:
		velocity.x = 0
		sprite.play("idle")
		return
	
	# 3. Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 4. Movement Logic (Walk vs Run)
	var direction = Input.get_axis("ui_left", "ui_right")
	var is_running = Input.is_key_pressed(KEY_SHIFT) # Hold Shift to run
	var current_speed = RUN_SPEED if is_running else WALK_SPEED

	if direction:
		velocity.x = direction * current_speed
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)

	# 5. Interaction Detection
	check_interactions()
	
	move_and_slide()

	# 6. Animation Logic
	if is_on_floor():
		if velocity.x != 0:
			if is_running:
				sprite.play("run")
			else:
				sprite.play("walk")
		else:
			sprite.play("idle")
	else:
		sprite.play("jump")

func check_interactions():
	# Finds the first Area2D inside Derek's Interaction bubble
	var areas = interaction_area.get_overlapping_areas()
	
	if areas.size() > 0:
		current_interactable = areas[0]
		prompt.visible = true  # Show the "E" icon
	else:
		current_interactable = null
		prompt.visible = false # Hide the "E" icon
