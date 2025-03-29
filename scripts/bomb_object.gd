extends StaticBody2D
@onready var bomb_object:Area2D = $bomb_object  
@onready var bomb_exploding: AnimatedSprite2D = $bomb_exploding
	
func _ready():
	
	if bomb_object:
		bomb_object.visible = true
		bomb_exploding.play("default")
		bomb_exploding.loop = false
	else:
		print("Error: bomb_object is not found!")
	if bomb_exploding:
		bomb_exploding.connect("animation_finished", Callable(self, "_on_bomb_exploding_animation_finished"))

	
<<<<<<< Updated upstream
func ready():
	$bomb_object.visible = true
	$bomb_object.play("default")
=======
>>>>>>> Stashed changes

func _physics_process(delta):
	if Global.bomb_visible == true and !bomb_exploding.is_playing():
		$bomb_exploding.play("explode")  # Play explosion animation once
		Global.bomb_visible = false

	# Check if animation is finished and stop it
	
		
func _on_bomb_exploding_animation_finished(anim_name: String) -> void:
	bomb_exploding.stop() 
	bomb_object.visible = false
	
