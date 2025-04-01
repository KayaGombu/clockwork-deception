extends CharacterBody2D
class_name Player

@onready var all_interactions = []
@onready var interactLabel = $"Interaction Components/InteractLabel"

func _ready():
	update_interactions()


const speed = 100;
var current_dir = "none"
func _physics_process(delta: float) -> void:
	player_movement(delta)
	
	if Input.is_action_just_pressed("Interact"):
		print("Interact key pressed!")

		execute_interaction()

func player_movement(delta):
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_anim(1)
		velocity.x=speed
		velocity.y =0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_anim(1)
		velocity.x=-speed
		velocity.y =0
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		play_anim(1)
		velocity.x=0
		velocity.y =speed
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		play_anim(1)
		velocity.x=0
		velocity.y =-speed
	else:
		play_anim(0)
		velocity.x=0
		velocity.y=0
		
	move_and_slide()
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	if dir == "right":
		anim.flip_h=false
		if movement ==1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "left":
		anim.flip_h=true
		if movement ==1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "down":
		anim.flip_h=true
		if movement ==1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	if dir == "up":
		anim.flip_h=true
		if movement ==1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")
func _on_enemy_player_spotted():
	pass
	
	
#intraction methods


func _on_interaction_area_area_entered(area: Area2D) -> void:
	print("Entered interaction area:", area)
	all_interactions.insert(0, area)
	update_interactions()

func _on_interaction_area_area_exited(area: Area2D) -> void:
	print("Exited interaction area:", area)
	all_interactions.erase(area)
	update_interactions()
	
func update_interactions():
	if all_interactions:
		interactLabel.text = all_interactions[0].interact_label
	else:
		interactLabel.text = ""
		
func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]

		# Ensure we are not interacting with the player's own interaction components
		if cur_interaction.is_in_group("player_interaction"):
			print("Ignoring self-interaction.")
			return
		
		print("Interacting with:", cur_interaction.name, "(", cur_interaction.get_class(), ")")

		# Move up the node tree until we find an interactable object (like the bomb)
		var interactable = cur_interaction
		while interactable and not interactable.has_method("interaction_interact"):
			interactable = interactable.get_parent()

		# If a valid interactable object is found, call its interaction method
		if interactable and interactable.has_method("interaction_interact"):
			interactable.interaction_interact()
		else:
			print("Error: No valid object found for interaction.")
