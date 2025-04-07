extends Camera2D

@export var speed := 200.0  # You can adjust this speed

func _process(delta):
	if Input.is_action_pressed("cam_right"):
		global_position.x += speed * delta
	elif Input.is_action_pressed("cam_left"):
		global_position.x -= speed * delta
