extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel2.text = "Score:" + str(SabotageData.sabotage_count)+ "/6"
	if SabotageData.sabotage_count ==0:
		$RichTextLabel4.text = "F"
	elif SabotageData.sabotage_count ==1:
		$RichTextLabel4.text = "D"
	elif SabotageData.sabotage_count ==2:
		$RichTextLabel4.text = "C"
	elif SabotageData.sabotage_count ==3:
		$RichTextLabel4.text = "B"
	elif SabotageData.sabotage_count ==4:
		$RichTextLabel4.text = "A-"
	elif SabotageData.sabotage_count ==5:
		$RichTextLabel4.text = "A"
	elif SabotageData.sabotage_count ==6:
		$RichTextLabel4.text = "A+"
	elif SabotageData.sabotage_count ==7:
		$RichTextLabel4.text = "S"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game_menu.tscn")
