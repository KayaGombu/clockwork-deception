extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var has_exploded = false  

func _ready():
	if animated_sprite_2d:
		animated_sprite_2d.play("idle")  
	else:
		print("Error: AnimatedSprite2D not found")

func interaction_interact():
	if has_exploded:
		return  # check if already triggered

	has_exploded = true 
	if animated_sprite_2d:
		animated_sprite_2d.play("boom")  # Play explosion animation
		print("Bomb triggered!")

		$CollisionShape2D.queue_free()  # Remove collision
		await animated_sprite_2d.animation_finished  # Wait for animation
		queue_free() 
	else:
		print("Error: AnimatedSprite2D not found in Bomb")
