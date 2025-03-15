extends Node2D
var player_spotted = false
var player : Node2D = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.name =="player":
			player_spotted =true
			player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
