extends ColorRect

signal cell_clicked(position, button)

var grid_position : Vector2i
var is_start := false
var is_end := false
var is_obstacle := false

func _ready():
	custom_minimum_size = Vector2(10, 10)
	connect("gui_input", _on_gui_input)
	update_appearance()

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("cell_clicked", grid_position, event.button_index)

func update_appearance():
	if is_start:
		color = Color.GREEN
	elif is_end:
		color = Color.RED
	elif is_obstacle:
		color = Color.BLACK
	else:
		color = Color.WHITE
