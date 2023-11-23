extends CanvasLayer

signal unpause

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var state = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.hide()

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
		$GridContainer.get_node("Button").grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	emit_signal("unpause")
