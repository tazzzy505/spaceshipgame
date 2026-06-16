extends Node3D

@export var lazerSpeed: int
@export var outerBounds: int = 10000
var startingPosition: Vector3
var body

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body = $Pivot/Body
	body.set_contact_monitor(true)
	add_to_group("lazer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis.z * lazerSpeed * delta
	
	#
	#if collision.get_collider().is_in_group("mob"):
			#var mob = collision.get_collider()
			## we check that we are hitting it from above.
			#if Vector3.UP.dot(collision.get_normal()) > 0.1:
				## If so, we squash it and bounce.
				#mob.squash()
				#target_velocity.y = bounce_impulse
				## Prevent further duplicate calls.


func _on_timer_timeout() -> void:
	queue_free()




func _on_body_body_entered(body: Node) -> void:
	queue_free()
