extends Node2D
# Called when the node enters the scene tree for the first time.
var time 
var sabotage_count = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	time = $Timer.time_left
	$"UI/Panel/TimerLabel".text = str(floor(time*2))
	$UI/Panel/SabotageLabel.text = "Sabotages:" + str(SabotageData.sabotage_count)


	
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://gameover.tscn")
		
