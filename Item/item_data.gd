extends Resource
class_name ItemData

@export var name: String =""
@export var index: int = 0
@export_multiline var description: String=""
@export var stachable: bool = false
@export var texture: AtlasTexture

func use(target, _index) -> void:
	target.changeIndex(_index)
