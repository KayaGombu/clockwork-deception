extends StaticBody2D


var bomb = 1
var animation_played = false
func _ready():
	pass
	#create the code for the sabotage popup being visible when within range

func _physics_process(delta):
	pass


func _on_sabotage_button_pressed():
	Global.button_pressed = true
	Global.bomb_visible = true
	print("Sabotage pressed") 
	
