extends StaticBody2D

func _ready():
	$sabotage_popup.visible = false
	

func _on_area_2d_body_entered(body):
	if body.has_method("player_sabotage_method"):
		print("openSabotage")
		$sabotage_popup.visible = true

func _on_area_2d_body_exited(body):
	$sabotage_popup.visible = false
	
	
	
