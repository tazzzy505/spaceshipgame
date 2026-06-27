extends Node3D

var reticle
var reticlePos
var ship
var reticlePoint3D
var raycastPlane
var raycastPlanePos
var lerpedRotation
var shooting
@export var lazerScene: PackedScene
var lazerInstance
@export var enemyScene: PackedScene
var enemyInstance
var spawnerArea: MeshInstance3D
var spawnRangeMax: int = 10
var spawnRangeMin: int = 0
var shoot_cooldown: float = 0.1
var camera: Camera3D
var test
@export var cameraPullThreshold: int = 20
var targetRoll
var maxRollDegrees = 40
var rollSpeed = 100
@export var explosionScene: PackedScene
var explosionInstance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship = $Mover/Ship
	reticlePoint3D = $Mover/Reticle3d
	spawnerArea = $Mover/SpawnerArea
	camera = $Mover/Camera3D
	test = $test
	
func spawnEnemy():
	enemyInstance = enemyScene
	var enemy = enemyInstance.instantiate()
	var aabb: AABB = spawnerArea.get_aabb()
	var mesh_global_transform: Transform3D = spawnerArea.global_transform
	var local_random_x = randf_range(aabb.position.x, aabb.end.x)
	var local_random_y = randf_range(aabb.position.y, aabb.end.y)
	var local_random_z = randf_range(aabb.position.z, aabb.end.z)
	
	var local_point = Vector3(local_random_x, local_random_y, local_random_z)
	
	var global_spawn_position: Vector3 = mesh_global_transform * local_point
	add_child(enemy)
	enemy.global_position = global_spawn_position
	enemy.destroyed.connect(onEnemyDestroyed)
	
	
func shoot():
	lazerInstance = lazerScene.instantiate()
	#var lazerInstanceLocation = get_node("Ship")
	lazerInstance.position = ship.position
	lazerInstance.rotation =  ship.rotation
	add_child(lazerInstance)
	
func onEnemyDestroyed(enemyPosition: Vector3):
	explosionInstance = explosionScene
	var explosion = explosionInstance.instantiate()
	var explosionPosition = enemyPosition
	add_child(explosion)
	explosion.global_position = explosionPosition
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ship.position.y = lerp(ship.position.y, reticlePoint3D.position.y,smoothstep(0.01,1,0.075))
	ship.position.x = lerp(ship.position.x, reticlePoint3D.position.x,smoothstep(0.01,1,0.075))
	
	

	if camera.position.x >= ship.position.x + cameraPullThreshold || camera.position.x >= ship.position.x - cameraPullThreshold:
		camera.position.x = lerp(camera.position.x, ship.position.x,smoothstep(0.01,1,0.075))
		
	if camera.position.y >= ship.position.y + cameraPullThreshold || camera.position.y >= ship.position.y - cameraPullThreshold:
		camera.position.y = lerp(camera.position.y, ship.position.y,smoothstep(0.01,1,0.075))
		
		
	ship.look_at(lerp(reticlePoint3D.position, ship.position,0.75), Vector3.UP, true)
	
	
	#if reticlePoint3D.position > ship.position-1:
		#ship.rotation.z = lerp(ship.rotation.z, ship.rotation.z + 5, 0.03)
	#if reticlePoint3D.position < ship.position+1:
		#ship.rotation.z = lerp(ship.rotation.z, ship.rotation.z - 5, 0.03)
	
	
	
	# 1. Calculate the horizontal distance/input direction
	# This measures how far away the reticle is on the X axis
	var horizontal_displacement = reticlePoint3D.global_position.x - ship.global_position.x
	
	# 2. Clamp the value so the ship doesn't flip upside down if the reticle is too far
	# This creates a value between -1.0 (hard left) and 1.0 (hard right)
	var rollFactor = clamp(horizontal_displacement, -1.0, 1.0)
	
	# 3. Calculate the target roll in radians
	# Inverting the roll_factor might be needed depending on your camera/axis setup
	var targetRoll = rollFactor * deg_to_rad(maxRollDegrees)
	
	# 4. Smoothly interpolate to the target roll using delta
	ship.rotation.z = lerp(ship.rotation.z, targetRoll, rollSpeed * delta)
		
		
		
	shooting = Input.is_action_pressed("shoot")
	shoot_cooldown = shoot_cooldown - delta
	while shoot_cooldown <= 0 and shooting:
		shoot_cooldown = 0.1
		shoot()
	pass
	#raycastPlanePos = raycastPlane.position
	#reticlePos = reticle.position
	#player.position = Vector3(reticlePos.x, reticlePos.y, 0)
	#print(reticlePos)
	


func _on_enemy_spawn_timer_timeout() -> void:
	spawnEnemy()
	
