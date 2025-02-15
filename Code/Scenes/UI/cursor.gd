extends TextureRect
class_name MenuCursor

@export_enum("Left", "Up", "Down", "Right") var direction: int = 0
@export_enum("Grid", "MultiList", "OneDirection") var movement_style: String = "OneDirection"
@export var pointer_offset: Array[Vector2] = [Vector2(10,0),
 Vector2(0,10),Vector2(0,-10),Vector2(-10,0)]

var point_options: Array = []
var pointing_at: Control
var array_index: int = 0
var item_index: int = 0
var moving: bool = false

#--------------------------------------
#region INITALIZATION
func _ready() -> void:
	change_direction(direction)
#endregion
#--------------------------------------

#--------------------------------------
#region VARIABLE CHANGING
func change_direction(new_direction: int) -> void:
	direction = new_direction
	match new_direction:
		2:
			rotation_degrees = 90
		3:
			rotation_degrees = 270
		4:
			rotation_degrees = 180

func change_pointing_at(new_node) -> void:
	pointing_at = new_node
	global_position = pointing_at.global_position + pointer_offset[direction]
#endregion
#--------------------------------------

#--------------------------------------
#region MENU NAVIGATION
func _process(_delta) -> void:
	if moving and movement_style == "OneDirection":
		if Input.is_action_just_pressed("Left"):
			item_movement(-6)
		if Input.is_action_just_pressed("Right"):
			item_movement(6)
		if Input.is_action_just_pressed("Up"):
			item_movement(-1)
		if Input.is_action_just_pressed("Down"):
			item_movement(1)
	elif moving and movement_style == "Grid":
		if Input.is_action_just_pressed("Left"):
			item_movement(-1)
		if Input.is_action_just_pressed("Right"):
			item_movement(1)
		if Input.is_action_just_pressed("Up"):
			change_lists(-1)
		if Input.is_action_just_pressed("Down"):
			change_lists(1)
	elif moving and movement_style == "Multilist":
		if Input.is_action_just_pressed("Left"):
			change_lists(-1)
		if Input.is_action_just_pressed("Right"):
			change_lists(1)
		if Input.is_action_just_pressed("Up"):
			item_movement(-1)
		if Input.is_action_just_pressed("Down"):
			item_movement(1)
	
	if Input.is_action_just_pressed("A"):
		#A selects the option and brings up thier actions
		pass
	
	if Input.is_action_just_pressed("B"):
		#B is to go back for reset position
		pass
	
	if Input.is_action_just_pressed("Start"):
		#Start will bring up explanations of the selected item
		pass
	
	if moving:
		if Input.is_action_pressed("Select"):
			pass
		if Input.is_action_just_released("Select"):
			pass
	

func item_movement(movement: int) -> void:
	var curr_in_array: int = point_options[array_index].find(pointing_at)
	item_index  = ((curr_in_array + movement)
	 % point_options[array_index].size())
	
	pointing_at = point_options[array_index][item_index]
	set_arrow_position()

func change_lists(movement: int) -> void:
	array_index = ((array_index + movement)
	 % point_options.size())
	
	pointing_at =  point_options[array_index][item_index]
	set_arrow_position()

func set_arrow_position():
	var anchor: Marker2D = pointing_at.get_node("Marker2D")
	print(anchor.global_position, pointing_at.global_position)
	global_position = anchor.global_position + pointer_offset[direction]
	
	#Grab the focus of any control item the cursor is on
	if point_options[array_index][item_index] is Button:
		print("A")
		point_options[array_index][item_index].grab_focus()
		print(get_viewport().gui_get_focus_owner())
#endregion
#--------------------------------------
