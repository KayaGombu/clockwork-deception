extends StaticBody2D
@export var player: CharacterBody2D
func _ready():
	$sabotage_popup.visible = false

func _on_area_2d_body_entered(body):
	if body == player:
		print("openSabotage")
		$sabotage_popup.visible = true

func _on_area_2d_body_exited(body):
	$sabotage_popup.visible = false
	
func _physics_process(delta):
	$bomb_object.visible = false
	if Global.button_pressed == true:
		Global.bomb_visible = true
		$bomb_object.visible = true	
