extends CanvasLayer

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://game_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
