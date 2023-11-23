extends Node

var main_menu_scene = load("res://Scenes/MainMenu.tscn")
var pause_menu_scene = load("res://Scenes/PauseMenu.tscn")
var test_level_scene = load("res://Levels/TestLevel.tscn")
var hidden_room_scene = load("res://Levels/HiddenRoom.tscn")
var player_scene = load("res://Scenes/Player.tscn")
var ui_scene = preload("res://Scenes/DUI.tscn")

var main_menu
var pause_menu
var current_level
var children
var doors
var pickups
var player
var dui
var spawn_point
var state = -1
var current_camera
var playerFeetCollider
var playerBodyCollider

var SCREEN_H = 1280
var SCREEN_V = 720

var game_started = false
var level_dict = {
	"TestLevel": test_level_scene,
	"HiddenRoom": hidden_room_scene
}

# ENTRY
func start_game():
	state = 0
	game_started = true
	main_menu.toggle()
	
	add_child(player)
	load_level("TestLevel")
	spawn_player()

# LOAD and SPAWN
func load_level(level_name):
	current_level = level_dict[level_name].instantiate()
	add_child(current_level)
	
	children = current_level.get_children()
	doors = []
	pickups = []
	var doorIndex = 0
	var pickupIndex = 0
	for child in children:
		if child.get_name().substr(0, 4) == "Door":
			doors.append(child)
			doors[-1].connect("entered", Callable(self, "_on_Door_entered"))
			doors[-1].doorID = doorIndex
			doorIndex += 1
		if child.get_name().substr(0, 4) == "Heal":
			pickups.append(child)
			pickups[-1].connect("pickedUp", Callable(self, "_on_Pickedup"))
			pickups[-1].pickupID = pickupIndex
			pickups[-1].pickupType = 1
			pickups[-1].pickupValue = 1
			pickupIndex += 1

func spawn_player():
	spawn_point = current_level.get_node("SpawnPoint")
	player.spawn(spawn_point.position)
	player.get_node("PlayerCam").make_current()
	current_camera = player.get_node("PlayerCam")
	playerFeetCollider = player.get_node("FeetCollider")
	playerBodyCollider = player.get_node("BodyCollider")
	
	add_child(dui)
	dui.init(SCREEN_H, SCREEN_V)
	dui.update_values(player.health)

func transition_level(level_name):
	player.despawn()
	current_level.queue_free()
	load_level(level_name)
	spawn_player()
	print("Finished transitioning")

# GAMEPLAY
func pickup(pickupID):
	if pickups[pickupID].pickupType == 1:
		damage_player(pickups[pickupID].pickupValue * -1)
		
	pickups[pickupID].pickup_me()

func damage_player(amount):
	player.take_damage(amount)
	dui.update_values(player.health)

# Called when the node enters the scene tree for the first time.
func _ready():
	player = player_scene.instantiate()
	dui = ui_scene.instantiate()
	main_menu = main_menu_scene.instantiate()
	pause_menu = pause_menu_scene.instantiate()
	add_child(main_menu)
	add_child(pause_menu)
	main_menu.connect("start", Callable(self, "_on_MainMenu_started"))
	pause_menu.connect("unpause", Callable(self, "_on_PauseMenu_unpaused"))

func _process(delta):
	if state == -1:
		return
	
	if state == 0:
		# var camera_position = current_camera.get_camera_position()
		var camera_position = current_camera.get_screen_center_position() 
		dui.update_offset(camera_position)
	
	if Input.is_action_just_released("ui_focus_next"):
		damage_player(1)
		
	if Input.is_action_pressed("ui_select"):
		for door in doors:
			if player.get_node("CheckCollider").overlaps_area(door.get_node("Switch")):
				door.open()
				
	if Input.is_action_pressed("ui_cancel"):
		if state == 0:
			get_tree().paused = true
			state = 1
			pause_menu.toggle()

# SIGNAL CONNECTIONS
func _on_MainMenu_started():
	start_game()

func _on_PauseMenu_unpaused():
	get_tree().paused = false
	state = 0
	pause_menu.toggle()
	
func _on_Door_entered(area, doorID):
	if area == playerFeetCollider:
		transition_level(doors[doorID].get_destination())
		
func _on_Pickedup(area, pickupID):
	if pickups[pickupID].available and area == playerBodyCollider:
		pickup(pickupID)
