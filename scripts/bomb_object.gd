extends StaticBody2D

	
func ready():
	$bomb_object.visible = true
	$bomb_object.play("default")




func _physics_process(delta):
	if Global.bomb_visible == true:
		$bomb_exploding.play("explode")
		Global.bomb_visible = false
		
