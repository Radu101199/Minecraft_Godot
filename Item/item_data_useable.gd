extends ItemData
class_name ItemDataUseable

@export var index_item: int

func use(target, slot_data) -> void:

	if index_item != 0:
		target.changeIndex(index)
