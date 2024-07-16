extends CharacterBody3D

@export var inventory_data: InventoryData
const SPEED = 8.0
const JUMP_VELOCITY = 12.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 24.0
var sensitivity = 0.002
var index: int = 0
signal toggle_inventory()

@onready var camera_3d = $Camera3D
@onready var ray_cast_3d = $Camera3D/RayCast3D
@onready var block_ourtline = $BlockOutline
signal place_block(pos, t)

@onready var save_load = $"../SaveLoad"

func _ready():
	PlayerManager.player = self
	save_load.load_game()
	self.global_position = save_load.global_position

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation.y = rotation.y - event.relative.x * sensitivity
		camera_3d.rotation.x = camera_3d.rotation.x - event.relative.y * sensitivity
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-70), deg_to_rad(80))
	
	if Input.is_action_just_pressed("ui_cancel"):
		save_load.save_game()
		get_tree().quit()
		
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	
	if Input.is_action_just_pressed("interact"):
		interact()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0
	
	if Input.is_action_just_pressed("left_click"):
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider().has_method("destroy_block") and (Input.mouse_mode != Input.MOUSE_MODE_VISIBLE):
				ray_cast_3d.get_collider().destroy_block(ray_cast_3d.get_collision_point()-
														ray_cast_3d.get_collision_normal())
	
	if Input.is_action_just_pressed("right_click"):
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider().has_method("place_block") and (Input.mouse_mode != Input.MOUSE_MODE_VISIBLE):
				ray_cast_3d.get_collider().place_block(ray_cast_3d.get_collision_point()+
														ray_cast_3d.get_collision_normal(), index)

	move_and_slide()

func interact() -> void:
	if ray_cast_3d.is_colliding():
		if !(ray_cast_3d.get_collider() is GridMap):
			ray_cast_3d.get_collider().player_interact()

func changeIndex(_index: int) -> void:
	index = _index

