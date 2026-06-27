extends Node3D

@export var terrainSpeed: int
@export var speed:int 

var nextTerrainTile
@export var terrainTileScene: PackedScene
var tileOffset: Vector3 = Vector3(0, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.z = position.z + speed * delta
	pass


func _on_terrain_spawner_timer_timeout() -> void:
	
	spawnNextTerrainTile()
	pass # Replace with function body.

func spawnNextTerrainTile():
	nextTerrainTile = terrainTileScene
	var tile = nextTerrainTile.instantiate()
	tile.position = tile.position + tileOffset
	tileOffset -= Vector3(0,0,800)
	add_child(tile)



func _on_terrain_delete_timer_timeout() -> void:
	
	pass # Replace with function body.
