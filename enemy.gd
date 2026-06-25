extends Node3D

var enemySpeed:float = 5.0
var body

var amplitude
var totalTime: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var body = $RigidBody3D
	body.set_contact_monitor(true)
	amplitude = randf() * 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta = delta * 1.0
	position.z += enemySpeed * delta
	
	position.y = (cos(totalTime)) * amplitude
	totalTime += delta
	
	#for infex in get_slide_collision_count()
	pass


func _on_rigid_body_3d_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		queue_free()
