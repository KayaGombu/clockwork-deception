extends Node

@onready var sabotages_label: Label = %PointsLabel


var sabotages = 0
func _process(delta: float) -> void:
	%TimerLabel.text = str(floor(%Timer.time_left))
func add_point():
	sabotages +=1
	print(sabotages)
	sabotages_label.text = "Sabotages: " + str(sabotages)
