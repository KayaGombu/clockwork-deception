extends CharacterBody2D
@export var player: CharacterBody2D
@export var SPEED: int = 80
@export var CHASE_SPEED: int = 100
@export var ACCELERATION: int = 160



@onready var sprite: Sprite2D = $Icon
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
	
func _physics_process(delta: float) -> void:
	movement(delta)
	look_for_player()
	
func look_for_player():
	for ray in sprite.get_children():
		if ray.is_colliding():
			if ray.get_collider() == player:
				chase_player()
			elif current_state == States.CHASE:
				stop_chase()
		elif current_state == States.CHASE:
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
		#velocity = velocity.move_toward(direction*SPEED, ACCELERATION*delta)
		get_parent().progress += SPEED/100.0
	else:
		velocity = velocity.move_toward(direction*CHASE_SPEED, ACCELERATION*delta)
	move_and_slide()

#func change_direction(dir) -> void:
		#if dir == "up":
			#for ray in sprite.get_children():
				#ray.target_position = Vector2.UP.rotated(ray.target_position.angle())				
		#elif dir == "down":
			#for ray in sprite.get_children():
				#ray.target_position = Vector2.DOWN.rotated(ray.target_position.angle())
		#elif dir == "left":
			#for ray in sprite.get_children():
				#ray.target_position = Vector2.LEFT.rotated(ray.target_position.angle())			
		#elif dir == "right":
			#for ray in sprite.get_children():
				#ray.target_position = Vector2.RIGHT.rotated(ray.target_position.angle())			
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
		else:
			
			if self.position.x>=left_bounds.x:
				direction = Vector2(-1,0)
			else:
				sprite.flip_h = true
				ray_cast.target_position = Vector2(200,0)
				ray_cast2.target_position = Vector2(200,20)
				ray_cast3.target_position = Vector2(200,-20)
	else:
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x ==1:
			sprite.flip_h = true
			ray_cast.target_position = Vector2(200,0)
			ray_cast2.target_position = Vector2(200,20)
			ray_cast3.target_position = Vector2(200,-20)
		else: 
			sprite.flip_h = false
			ray_cast.target_position = Vector2(-200,0)
			ray_cast2.target_position = Vector2(-200,20)
			ray_cast3.target_position = Vector2(-200,-20)
			

#
#func gen_raycasts() -> void:
	#var raycount = 4
	#for i in raycount:
		#var ray = RayCast2D.new()
		#var angle = deg_to_rad(5.0)*(i-raycount/2.0)
		#ray.target_position = Vector2.RIGHT.rotated(angle)*360
		#add_child(ray)
		#ray.enabled = true
		
	


func _on_timer_timeout() -> void:
	current_state = States.WANDER
	if current_state == States.CHASE:
		current_state == States.WANDER
