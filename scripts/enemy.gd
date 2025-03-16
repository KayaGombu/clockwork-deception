extends CharacterBody2D
@export var player: CharacterBody2D
@export var SPEED: int = 50
@export var CHASE_SPEED: int = 100
@export var ACCELERATION: int = 160



@onready var sprite: Sprite2D = $Icon
@onready var area: Area2D = $Area2D
@onready var collision: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var ray_cast: RayCast2D = $Icon/RayCast2D
@onready var ray_cast2: RayCast2D = $Icon/RayCast2D2
@onready var ray_cast3: RayCast2D = $Icon/RayCast2D3
@onready var timer: Timer = $Timer

var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2

enum States{
	WANDER,
	CHASE
}

var current_state = States.WANDER

func _ready():
	left_bounds = self.position+Vector2(-120,0)
	right_bounds = self.position+Vector2(120,0)
	area.connect("body_entered",Callable(self, "_on_area_2d_body_entered"))
	area.connect("body_exited",Callable(self, "_on_area_2d_body_exited"))
func _physics_process(delta: float) -> void:
	movement(delta)
	change_direction()
	look_for_player()
	
func look_for_player():
	for ray in [ray_cast,ray_cast2,ray_cast3]:
		if ray.is_colliding():
			var collider = ray_cast.get_collider()
		
			if collider == player:
				chase_player()
			elif current_state == States.CHASE:
				stop_chase()
	
	stop_chase()
		
func chase_player():
	timer.stop()
	current_state = States.CHASE
	
func stop_chase():
	#if timer.time_left<=0:
		#timer.start()
	if current_state == States.CHASE:
		timer.start()
func movement(delta: float) -> void:
	if current_state == States.WANDER:
		velocity = velocity.move_toward(direction*SPEED, ACCELERATION*delta)
	else:
		velocity = velocity.move_toward(direction*CHASE_SPEED, ACCELERATION*delta)
	move_and_slide()
	
func change_direction() -> void:
	#when it's in a wander state
	if current_state == States.WANDER:
		#when we change this, it could be based on animations
		#flips the raycast
		if sprite.flip_h:
			if self.position.x<=right_bounds.x:
				direction = Vector2(1,0)
			else:
				sprite.flip_h = false
				ray_cast.target_position = Vector2(-200,0)
				ray_cast2.target_position = Vector2(-200,20)
				ray_cast3.target_position = Vector2(-200,-20)
				flip_cone(true)
		else:
			
			if self.position.x>=left_bounds.x:
				direction = Vector2(-1,0)
			else:
				sprite.flip_h = true
				ray_cast.target_position = Vector2(200,0)
				ray_cast2.target_position = Vector2(200,20)
				ray_cast3.target_position = Vector2(200,-20)
				flip_cone(false)
	else:
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x ==1:
			sprite.flip_h = true
			ray_cast.target_position = Vector2(200,0)
			ray_cast2.target_position = Vector2(200,30)
			ray_cast3.target_position = Vector2(200,-30)
			flip_cone(true)
		else: 
			sprite.flip_h = false
			ray_cast.target_position = Vector2(-200,0)
			ray_cast2.target_position = Vector2(-200,20)
			ray_cast3.target_position = Vector2(-200,-20)
			flip_cone(false)
func flip_cone(is_facing_right: bool):
	var scale =1 if is_facing_right else -1
	area.scale.x = scale
	for i in range(collision.polygon.size()):
		collision.polygon[i].x *=1
	
#const SPEED = 300.0

#var vision_cone_angle = deg_to_rad(100.0)
#var angle_between_rays = deg_to_rad(5.0)
#var rayList = []
#
#signal player_spotted
#func _ready() -> void:
#
	#gen_raycasts()
#
#func _physics_process(delta: float) -> void:
	#$"Icon".set_modulate(Color(1,1,1,1))
	#for ray in rayList:
		#if ray.is_colliding() and ray.get_collider() is Player:
			#$"Icon".set_modulate(Color(100,1,1,1))
			#player_spotted.emit()
		#
#
#func gen_raycasts() -> void:
	#var raycount = 4
	#for i in raycount:
		#var ray = RayCast2D.new()
		#var angle = angle_between_rays*(i-raycount/2.0)
		#ray.target_position = Vector2.RIGHT.rotated(angle)*360
		#rayList.append(ray)
		#add_child(ray)
		#ray.enabled = true
		
	


func _on_timer_timeout() -> void:
	current_state = States.WANDER
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		chase_player()
		collision.modulate = Color(0, 1, 0)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		chase_player()
		collision.modulate = Color(1, 1, 1)
