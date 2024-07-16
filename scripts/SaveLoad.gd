class_name SaveLoad_Menu
extends Node
@onready var player = $"../Player"
@onready var grid_map = $"../GridMap"

var global_position:Vector3
var block_data
func save_game():

	var saved_game: SavedGame = SavedGame.new()
	saved_game.player_position = player.global_position
	#print(grid_map.get_meshes())
	var mesh_library = grid_map.get_mesh_library()
	for block_location in grid_map.get_used_cells():
		var block_index= grid_map.get_cell_item(block_location)
		saved_game.block_data.append([block_index, block_location])
		#print([block_type, block_location])
	
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game():
	
	var saved_game: SavedGame = load("user://savegame.tres") as SavedGame
	global_position = saved_game.player_position
	block_data = saved_game.block_data
	
