extends Node2D

var heart_scene = preload("res://Scenes/HeartSprite.tscn")

var SCREEN_H = 640
var SCREEN_V = 480

var hearts = []
var heartCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(screenWidth, screenHeight):
	SCREEN_H = screenWidth
	SCREEN_V = screenHeight
	
func update_values(healthAmount):
	for heart in hearts:
		heart.queue_free()
	heartCount = healthAmount
	hearts.clear()
	for i in range(healthAmount):
		var newHeart = heart_scene.instantiate()
		hearts.append(newHeart)
		add_child(newHeart)

func update_offset(offset):
	var ui_offset = Vector2(
		offset.x + (SCREEN_H / 2) - 16,
		offset.y - (SCREEN_V / 2) + 16
	)
	for i in range(heartCount):
		hearts[i].offset = ui_offset
		hearts[i].offset.x -= (16 * i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
