extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var has_exploded = false

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
	print("Bomb triggered!")  # Debugging: Confirm that the bomb interaction function is called

	if animated_sprite_2d:
		animated_sprite_2d.play("boom")  # Play the explosion animation
		print("Explosion animation playing.")  # Debugging: Check if the animation starts

		# Remove the bomb's collision shape so it doesn't interact further
		$CollisionShape2D.queue_free()

		# Wait for animation to finish (can add a timer or callback)
		print("Bomb exploded!")  # Debugging: Confirm explosion is complete

		# Optionally, you can add a timer here to remove the bomb after the animation finishes
		  # Remove the bomb after the explosion animation finishes
	else:
		print("Error: AnimatedSprite2D not found in Bomb")
