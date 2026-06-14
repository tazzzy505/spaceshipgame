extends Node3D

var enemySpeed:float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta = delta * 1.0
	position.z += enemySpeed * delta
	
	#for infex in get_slide_collision_count()
	pass
