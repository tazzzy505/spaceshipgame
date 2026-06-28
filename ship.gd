extends Node3D

var cooldown = 1


func _ready() -> void:
	
	pass
	
func _process(delta: float) -> void:
	
	pass
	
func _physics_process(delta: float) -> void:
	Eventbus.playerMoved.emit(global_position)
	pass


func _on_mesh_instance_3d_body_entered(body: Node) -> void:
	print(body.get_groups()) 
	if body.is_in_group("enemyLazer"):
		print("YA DED")
		queue_free()
	pass # Replace with function body.
