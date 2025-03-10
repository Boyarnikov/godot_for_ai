extends Control

@export var grid_size := Vector2i(40, 40)
@export var grid_cell_scene : PackedScene
@export var obstacle_probability: float = 0.3

var start_pos = null
var end_pos = null
var obstacles := []
var path := []
var checked := []

@onready var grid_container = $GridContainer
@onready var generate_button = $GenerateButton
@onready var toggle_algo_button = $ToggleAlgo

var variations = {"dijkstra": dijkstra, "star": star}
var variations_id = ["dijkstra", "star"]
var variation = 0

func _ready():
	initialize_grid()
	generate_button.connect("pressed", generate_random_map)
	toggle_algo_button.connect("pressed", change_algo)
	
func change_algo():
	variation = (variation + 1) % len(variations_id)
	toggle_algo_button.text = variations_id[variation]
	calculate_path()

func initialize_grid():
	grid_container.columns = grid_size.x
	for x in grid_size.x:
		for y in grid_size.y:
			print("init cell")
			print(Vector2i(x, y))
			var cell = grid_cell_scene.instantiate()
			cell.grid_position = Vector2i(x, y)
			cell.connect("cell_clicked", _on_cell_clicked)
			print(cell)
			grid_container.add_child(cell)

func _on_cell_clicked(position: Vector2i, button: int):
	var cell = get_cell_at_position(position)
	if button == MOUSE_BUTTON_LEFT:
		handle_left_click(position)
	elif button == MOUSE_BUTTON_RIGHT:
		handle_right_click(cell, position)

func handle_left_click(position):
	if start_pos == null:
		set_path_start(position)
	elif end_pos == null:
		set_path_end(position)
		calculate_path()
	else:
		set_path_start(position)
		set_path_end(null)
		path.clear()
		checked.clear()
		update_grid_appearance()
		

func handle_right_click(cell, position):
	cell.is_obstacle = not cell.is_obstacle
	if cell.is_obstacle:
		obstacles.append(position)
	else:
		obstacles.erase(position)
	if start_pos != null and end_pos != null:
		calculate_path()
	cell.update_appearance()

func set_path_start(position):
	clear_previous_start()
	start_pos = position
	get_cell_at_position(position).is_start = true
	update_grid_appearance()

func set_path_end(position):
	clear_previous_end()
	end_pos = position
	if position == null:
		return
	get_cell_at_position(position).is_end = true
	update_grid_appearance()

func clear_previous_start():
	if start_pos:
		get_cell_at_position(start_pos).is_start = false

func clear_previous_end():
	if end_pos:
		get_cell_at_position(end_pos).is_end = false

func get_cell_at_position(position: Vector2i):
	for cell in grid_container.get_children():
		if cell.grid_position == position:
			return cell
	return null

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and start_pos != null and end_pos != null:
		calculate_path()

func calculate_path():
	if start_pos == null or end_pos == null:
		return
	path = variations[variations_id[variation]].call(start_pos, end_pos)
	update_grid_appearance()

func dijkstra(start: Vector2i, end: Vector2i) -> Array:
	var distances = {}
	var previous = {}
	var queue = []
	checked = []
	
	for cell in grid_container.get_children():
		distances[cell.grid_position] = INF
		previous[cell.grid_position] = null
	distances[start] = 0
	queue.append({"pos": start, "distance": 0})
	
	while not queue.is_empty():
		queue.sort_custom(func(a, b): return a.distance < b.distance)
		var current = queue.pop_front()
		var current_pos = current.pos
		checked.append(current_pos)
		
		if current_pos == end:
			break
		
		for neighbor in get_neighbors(current_pos):
			if neighbor in obstacles: continue
			var tentative = distances[current_pos] + 1
			if tentative < distances[neighbor]:
				distances[neighbor] = tentative
				previous[neighbor] = current_pos
				queue.append({"pos": neighbor, "distance": tentative})
	
	return reconstruct_path(previous, end)


func star(start: Vector2i, end: Vector2i) -> Array:
	var distances = {}
	var previous = {}
	var queue = []
	checked = []
	
	for cell in grid_container.get_children():
		distances[cell.grid_position] = INF
		previous[cell.grid_position] = null
	distances[start] = 0
	queue.append({"pos": start, "distance": 0, "priority": heuristic(start, end)})
	
	while not queue.is_empty():
		queue.sort_custom(func(a, b): return a.priority < b.priority)
		var current = queue.pop_front()
		var current_pos = current.pos
		checked.append(current_pos)
		
		if current_pos == end:
			break
		
		for neighbor in get_neighbors(current_pos):
			if neighbor in obstacles: continue
			var tentative = distances[current_pos] + 1
			if tentative < distances[neighbor]:
				distances[neighbor] = tentative
				previous[neighbor] = current_pos
				var priority = tentative + heuristic(neighbor, end)
				queue.append({"pos": neighbor, "distance": tentative, "priority": priority})
	
	return reconstruct_path(previous, end)

func heuristic(pos: Vector2i, end: Vector2i) -> int:
		return abs(pos.x - end.x) + abs(pos.y - end.y)

func get_neighbors(pos: Vector2i) -> Array:
	var neighbors = []
	var directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	for dir in directions:
		var neighbor = pos + dir
		if is_valid_position(neighbor):
			neighbors.append(neighbor)
	return neighbors

func is_valid_position(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < grid_size.x and pos.y < grid_size.y

func reconstruct_path(previous, end: Vector2i) -> Array:
	var path = []
	var current = end
	while current != null:
		path.insert(0, current)
		current = previous.get(current)
	return path if path.size() > 0 and path[0] == start_pos else []

func update_grid_appearance():
	for cell in grid_container.get_children():
		cell.update_appearance()
	for pos in checked:
		var cell = get_cell_at_position(pos)
		if cell and not cell.is_start and not cell.is_end:
			cell.color = Color.ORANGE
	for pos in path:
		var cell = get_cell_at_position(pos)
		if cell and not cell.is_start and not cell.is_end:
			cell.color = Color.YELLOW

func generate_random_map():
	clear_previous_end()
	clear_previous_start()
	obstacles.clear()
	path.clear()
	checked.clear()
	
	for cell in grid_container.get_children():
		var make_obstacle = randf() < obstacle_probability
		cell.is_obstacle = make_obstacle
		if make_obstacle:
			obstacles.append(cell.grid_position)
		else:
			cell.is_start = false
			cell.is_end = false
		cell.update_appearance()
