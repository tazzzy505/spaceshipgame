extends Node3D

@export var terrainSpeed: int

var nextTerrainTile
@export var terrainTileScene: PackedScene
var tileOffset: Vector3 = Vector3(0, 0, 100)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_terrain_spawner_timer_timeout() -> void:
	spawnNextTerrainTile()
	pass # Replace with function body.

func spawnNextTerrainTile():
	nextTerrainTile = terrainTileScene
	var tile = nextTerrainTile.instantiate()
	tile.position = tile.position + tileOffset
	tileOffset += Vector3(0,0,50)
	add_child(tile)
