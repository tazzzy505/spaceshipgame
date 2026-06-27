extends Node3D

@onready var particles = $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	particles.emitting = true
	
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
