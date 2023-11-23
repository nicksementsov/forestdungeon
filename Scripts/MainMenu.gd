extends CanvasLayer

signal start

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$GridContainer.get_node("Button").grab_focus()
	
func hide_all():
	for child in get_children():
		child.hide()
		
func show_all():
	for child in get_children():
		child.show()

func toggle():
	if state == 0:
		state = -1
		hide_all()
	elif state == -1:
		state = 0
		show_all()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	emit_signal("start")


func _on_Button2_pressed():
	get_tree().quit()
