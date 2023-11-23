extends StaticBody2D

signal entered

var closed = true
var blocker
var doorID = -1
@export var destination = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	blocker = $Blocker

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_area_entered(area):
	emit_signal("entered", area, doorID)

func open():
	if closed:
		closed = false
		blocker.disabled = true
		$DoorOpenNorth.visible = true
		$DoorClosedNorth.visible = false

func get_destination():
	return destination
