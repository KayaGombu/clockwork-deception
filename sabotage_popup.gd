extends StaticBody2D

var bomb = 1

func _ready():
	pass

func _on_sabotage_button_pressed():
	Global.bomb_visible = true
	print("Sabotage pressed")

	
