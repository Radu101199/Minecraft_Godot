extends GridMap

var save_path = "/Users/paunradu/Developer/GraficaMaterie"


@onready var save_load = $"../SaveLoad"

func _ready():
	self.clear()
	save_load.load_game()
	for block_data in save_load.block_data:
		#print(block_data[1], block_data[0])
		self.set_cell_item(block_data[1], block_data[0])
	
func destroy_block(world_coordinate):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, -1)

	
func place_block(world_coordinate, block_index):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, block_index)


func save_world():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	for block in self.get_used_cells():
		save_file.store[block.x]
		save_file.store[block.y]
		save_file.store[block.z]


	
func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)

func load():
	var save_file 
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		while file.get_position() != save_file.get_len():
			var block = Vector3()
			block.x = save_file.get()
			block.y = save_file.get()
			block.z = save_file.get()
