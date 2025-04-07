extends CharacterBody2D
class_name Player

@onready var all_interactions = []
@onready var interactLabel = $InteractionComponents/InteractLabel
@onready var interact_label: Label = $InteractionComponents/InteractLabel

var sprint_speed = 100
var walk_speed = 70
var max_speed = 70


func _ready():
	update_interactions()

#const speed = 100;


var current_dir = "none"

func _physics_process(delta: float) -> void:
	player_movement(delta)

	if Input.is_action_just_pressed("Interact"):
		print("Interact key pressed!")
		execute_interaction()  
		
		#running
	if Input.is_action_pressed("Sprint"):
		max_speed = sprint_speed
	else:
		max_speed = walk_speed

func player_movement(delta):
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = max_speed
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -max_speed
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = max_speed
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -max_speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	# Check if the player is sprinting
	if max_speed == sprint_speed:
		# Sprinting animations
		if dir == "right":
			anim.flip_h = false
			if movement == 1:
				anim.play("side_sprint")
			elif movement == 0:
				anim.play("side_idle")
		if dir == "left":
			anim.flip_h = true
			if movement == 1:
				anim.play("side_sprint")
			elif movement == 0:
				anim.play("side_idle")
		if dir == "down":
			anim.flip_h = true
			if movement == 1:
				anim.play("front_sprint")
			elif movement == 0:
				anim.play("front_idle")
		if dir == "up":
			anim.flip_h = true
			if movement == 1:
				anim.play("back_sprint")
			elif movement == 0:
				anim.play("back_idle")
	else:
		# Regular walking animations
		if dir == "right":
			anim.flip_h = false
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				anim.play("side_idle")
		if dir == "left":
			anim.flip_h = true
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				anim.play("side_idle")
		if dir == "down":
			anim.flip_h = true
			if movement == 1:
				anim.play("front_walk")
			elif movement == 0:
				anim.play("front_idle")
		if dir == "up":
			anim.flip_h = true
			if movement == 1:
				anim.play("back_walk")
			elif movement == 0:
				anim.play("back_idle")

func _on_enemy_player_spotted():
	pass

# Interaction methods

func _on_interaction_area_area_entered(area: Area2D) -> void:
	print("Entered interaction area:", area)
	all_interactions.insert(0, area)  # Add the bomb to the interactions list
	update_interactions()

func _on_interaction_area_area_exited(area: Area2D) -> void:
	print("Exited interaction area:", area)
	all_interactions.erase(area)  # Remove the bomb from the interactions list
	update_interactions()

func update_interactions():
	if interactLabel == null:
		print("Error: Interact label not found!")
		return  # Avoid crash

		

	if all_interactions:
		interactLabel.text = all_interactions[0].interact_label
		interactLabel.visible = true  
	else:
		interactLabel.visible = false

func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]

		if cur_interaction.is_in_group("player_interaction"):
			print("Ignoring self-interaction.")
			return
		
		print("Interacting with:", cur_interaction.name, "(", cur_interaction.get_class(), ")")

		var interactable = cur_interaction
		while interactable and not interactable.has_method("interaction_interact"):
			interactable = interactable.get_parent()

		if interactable and interactable.has_method("interaction_interact"):
			interactable.interaction_interact() # trigger the bomb's explosion
		else:
			print("Error: No valid object found for interaction.")
