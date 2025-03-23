extends CharacterBody2D
@export var player: CharacterBody2D
@export var walls: StaticBody2D
@export var SPEED: int = 40
@export var CHASE_SPEED: int = 60
@export var ACCELERATION: int = 65
@onready var nav_agent: NavigationAgent2D = $Navigation/NavigationAgent2D


@onready var sprite: Sprite2D = $Icon
@onready var area: Area2D = $aggro/Area2D
@onready var collision: CollisionPolygon2D = $aggro/Area2D/CollisionPolygon2D
@onready var ray_cast: RayCast2D = $Icon/RayCast2D
@onready var ray_cast2: RayCast2D = $Icon/RayCast2D2
@onready var ray_cast3: RayCast2D = $Icon/RayCast2D3
@onready var recalcTimer: Timer = $Navigation/recalcTimer


var home_pos = Vector2.ZERO
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2


enum States{
	WANDER,
	CHASE
}
var chasing_player = false
var current_state = States.WANDER
var vision_points = []
func _ready():
	home_pos = self.global_position
	left_bounds = self.position+Vector2(-120,0)
	right_bounds = self.position+Vector2(120,0)
	area.connect("body_entered",Callable(self, "_on_area_2d_body_entered"))
	area.connect("body_exited",Callable(self, "_on_area_2d_body_exited"))
	recalcTimer.connect("timeout", Callable(self, "recalc_path"))
	for ray in sprite.get_children():
		if ray is RayCast2D:
			ray.collision_mask = player.collision_layer
func _physics_process(delta: float) -> void:
	if current_state == States.CHASE:
		recalc_path()
	movement(delta)
	move_and_slide()
	change_direction()
	look_for_player()

func look_for_player():
#This function uses raycasts to detect players and walls
	var player_spotted = false
	for ray in sprite.get_children():
		if ray is RayCast2D:
			ray.enabled = true
			if ray.is_colliding() and ray.get_collider() == player:
				player_spotted = true
				break
	if player_spotted: #once it spots the enemy, initate chase state
		chase_player()
	else:
		pass


func chase_player():
#this function starts the chase state
	current_state = States.CHASE
	chasing_player = true
	recalc_path()#finds the best path to chase the player
	
func stop_chase():
#this function starts the timer and ends the chase state
	current_state = States.WANDER
	chasing_player = false
	recalc_path()
		
func movement(delta: float) -> void:
#this function handles the movement of the enemy
	print("Current Direction: ", direction)
	if current_state == States.WANDER:
		velocity = velocity.move_toward(direction*SPEED, ACCELERATION*delta)
	elif current_state == States.CHASE:
		if nav_agent.is_navigation_finished():
			return
		var next_path_pos = nav_agent.get_next_path_position()
		var newDirection = (next_path_pos - global_position).normalized()
		velocity = velocity.move_toward(newDirection*CHASE_SPEED, ACCELERATION*delta)
		print("🟠 Moving towards:", next_path_pos, " Current Pos:", global_position, "Direction:", direction)
		
	
	
func recalc_path():
#every 0.5 seconds, this determines the best possible path to get to the player
	if current_state == States.CHASE and player:
		nav_agent.target_position = player.global_position
	else:
		nav_agent.target_position = home_pos
	
	print("New target position:", nav_agent.target_position)
func change_direction() -> void:
	#this function changes the direction of the enemy
	#when it's in a wander state
	if current_state == States.WANDER:
		#when we change this, it could be based on animations
		#flips the raycast
		if sprite.flip_h:
			if self.position.x<=right_bounds.x:
				direction = Vector2(1,0)
			else:
				sprite.flip_h = false
				ray_cast.target_position = Vector2(-190,0)
				ray_cast2.target_position = Vector2(-190,20)
				ray_cast3.target_position = Vector2(-190,-20)
				flip_cone(true)
		else:
			
			if self.position.x>=left_bounds.x:
				direction = Vector2(-1,0)
			else:
				sprite.flip_h = true
				ray_cast.target_position = Vector2(190,0)
				ray_cast2.target_position = Vector2(190,20)
				ray_cast3.target_position = Vector2(190,-20)
				flip_cone(false)
	else:
		direction = (player.position - self.position).normalized()
		#direction = sign(direction)
		if direction.x >0:
			sprite.flip_h = true
			ray_cast.target_position = Vector2(200,0)
			ray_cast2.target_position = Vector2(200,30)
			ray_cast3.target_position = Vector2(200,-30)
			flip_cone(false)
		else: 
			sprite.flip_h = false
			ray_cast.target_position = Vector2(-200,0)
			ray_cast2.target_position = Vector2(-200,20)
			ray_cast3.target_position = Vector2(-200,-20)
			flip_cone(true)
	print("New Direction: ", direction)
func flip_cone(is_facing_right: bool):
#this function flips the vision cone
	var scale =1 if is_facing_right else -1
	area.scale.x = scale
	#for i in range(collision.polygon.size()):
		#collision.polygon[i].x *= 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		chase_player()
		collision.modulate = Color(0, 1, 0)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		chase_player()
		collision.modulate = Color(1, 1, 1)

func _on_deaggro_range_area_exited(area: Area2D) -> void:
	#once it gets out of range (Deaggro Range), it goes back to the original position
	if area.owner ==player:
		current_state = States.WANDER
		stop_chase()
		recalc_path()
