extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var has_exploded = false

@onready var sabotage_label = $"../UI/Panel/SabotageLabel" # Reference to the label in the main scene

#var sabotage_count: int = 0  # Counter to track sabotage count
signal sabatoge
func _ready():
	if animated_sprite_2d:
		animated_sprite_2d.play("idle")  # Start with idle animation
	else:
		print("Error: AnimatedSprite2D not found in Bomb")

func interaction_interact():
	if has_exploded:
		print("Bomb has already exploded. Ignoring the trigger.")  # Debugging
		return  
		
	has_exploded = true
	print("Bomb triggered!")  

	# Increase the sabotage count
	SabotageData.sabotage_count += 1
	print("Bomb sabotaged! Total sabotages: ", SabotageData.sabotage_count)  # Debugging
	if sabotage_label:
		sabotage_label.text = "Sabotages: " + str(SabotageData.sabotage_count)
	else:
		print("⚠️ sabotage_label is null — couldn't find the node!")

	
	if animated_sprite_2d:
		animated_sprite_2d.play("boom")  # Play the explosion animation
		print("Explosion animation playing.")  # Debugging

		$CollisionShape2D.queue_free()  

		print("Bomb exploded!")  
	else:
		print("Error: AnimatedSprite2D not found in Bomb")
		
