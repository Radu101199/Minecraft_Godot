extends Control
@onready var player_inventory = $PlayerInventory
@onready var grabbed_slot = $GrabbedSlot
@onready var external_inventory: PanelContainer = $ExternalInventory

var grabbed_slot_data: SlotData
var external_inventory_owner
	
func _physics_process(delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5, 5)
		
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = _external_inventory_owner.inventory_data
	
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)

	external_inventory.show()

func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		external_inventory.clear_inventory_data(inventory_data)

		external_inventory.hide()
		external_inventory_owner = null

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	#print("%s %s %s " % [inventory_data, index, button])
	
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
