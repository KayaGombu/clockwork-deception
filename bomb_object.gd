extends StaticBody2D

func ready():
	pass

func _process(delta):
	$bomb_object.visible = true
	$bomb_object.play("explode")
	
