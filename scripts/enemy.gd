extends CharacterBody2D

const SPEED = 300.0
var vision_cone_angle = deg_to_rad(100.0)
var angle_between_rays = deg_to_rad(5.0)
var rayList = []

signal player_spotted
func _ready() -> void:

	gen_raycasts()

func _physics_process(delta: float) -> void:
	$"Icon".set_modulate(Color(1,1,1,1))
	for ray in rayList:
		if ray.is_colliding() and ray.get_collider() is Player:
			$"Icon".set_modulate(Color(100,1,1,1))
			player_spotted.emit()
		

func gen_raycasts() -> void:
	var raycount = 4
	for i in raycount:
		var ray = RayCast2D.new()
		var angle = angle_between_rays*(i-raycount/2.0)
		ray.target_position = Vector2.RIGHT.rotated(angle)*360
		rayList.append(ray)
		add_child(ray)
		ray.enabled = true
		
	
