extends Node

@onready var sabotages_label: Label = %PointsLabel


var sabotages = 0

func add_point():
	sabotages +=1
	print(sabotages)
	sabotages_label.text = "Sabotages: " + str(sabotages)
