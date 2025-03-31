extends StaticBody2D


var bomb = 1
var animation_played = false
func _ready():
	$bomb_icon.play("bomb")
	bomb = 1
	#create the code for the sabotage popup being visible when within range

func _physics_process(delta):
	
	if self.visible and bomb ==1:
		if bomb == 1:
			$bomb_icon.play("bomb")
			animation_played = true
			bomb =-1
		

func _on_sabotage_button_pressed():
	Global.button_pressed = true
	Global.bomb_visible = true
	print("Sabotage pressed") 
	
