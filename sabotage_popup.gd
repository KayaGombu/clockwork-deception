extends StaticBody2D


var bomb = 1
func _ready():
	$bomb_icon.play("bomb")
	bomb = 1
	#create the code for the sabotage popup being visible when within range

func _process(delta):
	if self.visible == true:
		if bomb == 1:
			$bomb_icon.play("bomb")
		

func _on_sabotage_button_pressed():
	Global.button_pressed = true
	Global.bomb_visible = true
	print("Sabotage pressed") 
	
