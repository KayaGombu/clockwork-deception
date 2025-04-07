extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var has_exploded = false

@onready var game_manager = get_node("res://game_manager.gd")

func _ready():
	if animated_sprite_2d:
		animated_sprite_2d.play("idle")  # Start with idle animation
	else:
		print("Error: AnimatedSprite2D not found in Bomb")

# This function is called by the player to trigger the explosion
func interaction_interact():
	if has_exploded:
		print("Bomb has already exploded. Ignoring the trigger.")  # Debugging
		return  # Prevent re-triggering if the bomb has already exploded

	has_exploded = true
	print("Bomb triggered!")  
	
	if game_manager:
		game_manager.add_point()
		print("Point added!")  # Debugging: Check if the point is added correctly
	else:
		print("Error: GameManager not found!")


	if animated_sprite_2d:
		animated_sprite_2d.play("boom")  # Play the explosion animation
		print("Explosion animation playing.")  # Debugging: Check if the animation starts

		$CollisionShape2D.queue_free()

		print("Bomb exploded!")  
		
	
	else:
		print("Error: AnimatedSprite2D not found in Bomb")
