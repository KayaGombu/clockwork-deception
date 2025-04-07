extends CharacterBody2D
@export var player: CharacterBody2D
@export var walls: StaticBody2D
@export var SPEED: int = 100
@export var CHASE_SPEED: int = 35
@export var ACCELERATION: int = 65

@onready var nav_agent: NavigationAgent2D = $Navigation/NavigationAgent2D
@onready var vision_pivot: Node2D = $vision_pivot
@onready var vision: PointLight2D = $PointLight2D
@onready var recalcTimer: Timer = $Navigation/recalcTimer

var movement_dir: Vector2 = Vector2.ZERO
var home_pos = Vector2.ZERO
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2
var entityDetection := {}
var ray_list = []
enum States{
	WANDER,
	CHASE,
	RETURN
}
var chasing_player = false
var current_state = States.WANDER
var vision_points = []
func _ready():
	home_pos = self.global_position
	left_bounds = self.position+Vector2(-120,0)
	right_bounds = self.position+Vector2(120,0)
	recalcTimer.connect("timeout", Callable(self, "recalc_path"))
	$"aggro/Deaggro Range".connect("body_exited", Callable(self, "_on_deaggro_body_exited"))
	gen_raycasts()
	for ray in ray_list:
		if ray is RayCast2D:
			ray.collision_mask = player.collision_layer
func _physics_process(delta: float) -> void:
	if velocity.length() > 0.1:  # Avoid rotating when idle
		var target_angle = velocity.angle()
		self.rotation = lerp_angle(self.rotation, target_angle, 5 * delta)
	if current_state == States.CHASE:
		print("chasing")
		chase_player(delta)
	update_animation()
	movement(delta)
	move_and_slide()
	look_for_player()

	self.rotation = 0
	$AnimatedSprite2D.rotation = 0

func look_for_player():
#This function uses raycasts to detect players and walls
	var player_spotted = false
	for ray in ray_list:
		if ray.is_colliding():
			#print("collide")
			if ray.get_collider() == player:
				player_spotted = true
				$AnimatedSprite2D.rotation = 0
				update_animation()
				print("player spotted")
				break
	if player_spotted: #once it spots the enemy, initate chase state
		current_state = States.CHASE
	else:
		pass
func chase_player(delta: float) -> void:
#this function starts the chase state
	#finds the best path to chase the player
	nav_agent.target_position = player.global_position
	if nav_agent.is_navigation_finished():
		return
	var next_path_pos = nav_agent.get_next_path_position()
	var newDirection = (next_path_pos - global_position).normalized()
	velocity = velocity.move_toward(newDirection*CHASE_SPEED, ACCELERATION*delta)
	$AnimatedSprite2D.rotation = 0

	vision_pivot.look_at(next_path_pos)
	vision_pivot.rotation = (next_path_pos - vision_pivot.global_position).angle() + deg_to_rad(90)
	move_and_slide()
	
	
func stop_chase():
#this function starts the timer and ends the chase state
	current_state = States.RETURN
	nav_agent.target_position = get_parent().global_position
		
func movement(delta: float) -> void:
#this function handles the movement of the enemy
	if current_state == States.WANDER:
		position = Vector2(0,0)
		#print("moving")
		get_parent().progress += SPEED/100.0
	if current_state == States.RETURN:
		if nav_agent.is_navigation_finished():
			rotation = deg_to_rad(90)
			current_state = States.WANDER
			return
		var next_path_pos = nav_agent.get_next_path_position()
		velocity = global_position.direction_to(next_path_pos) * SPEED/5
		var newDirection = global_position.direction_to(next_path_pos)

		movement_dir = newDirection

		if move_and_slide():
			velocity = velocity.slide(get_last_slide_collision().get_normal())
func update_animation():#get rid of function if you want to remove the animatedsprite
	var NewMovement = velocity
	if current_state == States.WANDER:
		var path_follow = get_parent()
		var prev_pos = path_follow.global_position
		path_follow.progress += SPEED / 550.0
		var new_pos = path_follow.global_position
		NewMovement = (new_pos - prev_pos).normalized() * SPEED

		if prev_pos != new_pos:
			vision_pivot.look_at(new_pos)
			vision_pivot.rotation = (new_pos - vision_pivot.global_position).angle() + deg_to_rad(90)

		path_follow.rotation = 0 
		self.rotation = 0
	if abs(NewMovement.x) > abs(NewMovement.y):  # Moving more horizontally
		if NewMovement.x > 0:
			$AnimatedSprite2D.play("right")
		elif NewMovement.x<0:
			$AnimatedSprite2D.play("left")
	else:  # Moving more vertically
		if NewMovement.y < 0:
			$AnimatedSprite2D.play("walk")  # Up
		elif NewMovement.y>0:
			$AnimatedSprite2D.play("down")  # Down
	
	$AnimatedSprite2D.rotation = 0


func gen_raycasts():
	var cone_angle = deg_to_rad(54.0)
	var view_range = 400.0
	var angle_between = deg_to_rad(5.0)
	var num_rays = cone_angle/angle_between
	for i in num_rays:
		var ray = RayCast2D.new()
		var angle = angle_between * (i-num_rays/2.0)
		ray.target_position = Vector2.UP.rotated(angle)*view_range
		vision_pivot.add_child(ray)
		ray_list.append(ray)
		ray.enabled = true
func _on_deaggro_range_body_exited(body: Node2D) -> void:
	print("Exited:", body.name)
	if body ==player:
		stop_chase()
		
