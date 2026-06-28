extends Node3D

@export var enemySpeed:float
var body
@export var enemyLazer: PackedScene

var amplitude
var totalTime: float = 1.0
signal destroyed(deathPosition: Vector3)
var health: int = 5
var flashMaterial: StandardMaterial3D
@export var flashDuration: float = 0.15
@export var attackTimerMax: float = 2.0
var attackTimer:float = 2
var targetPosition: Vector3
@export var attackChance: float
var randomCoordinate: Vector3
@export var range:int
var speed: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flashMaterial = StandardMaterial3D.new()
	flashMaterial.albedo_color = Color.WHITE # The flash color
	# Optional: Make it look like it's glowing / unlit
	flashMaterial.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED 
	#var body = $RigidBody3D
	#body.set_contact_monitor(true)
	amplitude = randf() * 2
	randomCoordinate = Vector3(randomSpawnRangeReturn(),randomSpawnRangeReturn(),0)
	speed =  randf_range(1,5)
	enemySpeed =  randf_range(1,10)
	Eventbus.playerMoved.connect(onPlayerMoved)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta = delta * 1.0
	position.z += enemySpeed * delta
	#
	position.y = (cos(totalTime)) * amplitude
	totalTime += delta
	attackTimer = attackTimer - delta
	position.move_toward(randomCoordinate, speed * delta)
	if attackTimer <= 0:
		attackTimer = attackTimerMax
		shoot()
	#for infex in get_slide_collision_count()
	pass


func _on_rigid_body_3d_body_entered(body: Node) -> void:
	if body.is_in_group("lazer"):
		health = health - 1
		flashDamage()
		if health <= 0:
			destroyed.emit(global_position)
			queue_free()
	if body.is_in_group("eraser"):
		queue_free()

func flashDamage():
	# Find every MeshInstance 3D inside your imported .glb
	var meshes = find_all_meshes(self)
	
	# Step 1: Apply the flash material override
	for mesh in meshes:
		mesh.material_override = flashMaterial
		
	# Step 2: Wait a split second
	await get_tree().create_timer(flashDuration).timeout
	
	# Step 3: Clear the override so the model goes back to its normal textures
	for mesh in meshes:
		mesh.material_override = null

# Helper function to recursively find all meshes in your .glb hierarchy
func find_all_meshes(current_node: Node) -> Array[MeshInstance3D]:
	var results: Array[MeshInstance3D] = []
	if current_node is MeshInstance3D:
		results.append(current_node)
	for child in current_node.get_children():
		results.append_array(find_all_meshes(child))
	return results
func shoot() -> void:
	if randf() > attackChance:
		var enemyLazerInstance = enemyLazer.instantiate()
		get_tree().current_scene.add_child(enemyLazerInstance)
		enemyLazerInstance.global_position = self.global_position
		#enemyLazerInstance.rotation = self.rotation
		#enemyLazerInstance.rotate_y(deg_to_rad(270))
		#enemyLazerInstance.look_at(targetPosition)
		enemyLazerInstance.global_transform = enemyLazerInstance.global_transform.looking_at(targetPosition, Vector3.UP)
		#print(enemyLazerInstance.transform.rotation)
		#print("Target: ", targetPosition, " | Laser Pos: ", self.global_position)
		
func onPlayerMoved(newPosition: Vector3): 
	
	if newPosition == Vector3(0, 0, 1):
		return
	targetPosition = newPosition

func randomSpawnRangeReturn() -> float:
	var randomRangeReturn = randf_range(range * -1, range)
	return randomRangeReturn
