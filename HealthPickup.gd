extends Area2D

signal pickedUp

var pickupID = -1
var pickupType = -1
var pickupValue = -1
var available = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HealthPickup_area_entered(area):
	emit_signal("pickedUp", area, pickupID)

func pickup_me():
	available = false
	self.hide()
