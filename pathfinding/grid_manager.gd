const MIN_ROOM_SIZE = 4
const MAX_ROOM_SIZE = 8
const MAX_ROOMS = 15
const CORRIDOR_WIDTH = 1

var rooms: Array[Rect2i] = []

func generate_random_map():
	# Clear previous data
	walkable_cells = initialize_2d_array(false)
	rooms.clear()
	
	# Phase 1: Generate rooms
	generate_rooms()
	
	# Phase 2: Connect rooms
	connect_rooms()
	
	# Phase 3: Fill remaining space
	fill_non_accessible_areas()

func initialize_2d_array(value: bool) -> Array:
	var arr := []
	for x in GRID_WIDTH:
		arr.append([])
		for y in GRID_HEIGHT:
			arr[x].append(value)
	return arr

func generate_rooms():
	var rng = RandomNumberGenerator.new()
	
	for _i in range(MAX_ROOMS):
		var width = rng.randi_range(MIN_ROOM_SIZE, MAX_ROOM_SIZE)
		var height = rng.randi_range(MIN_ROOM_SIZE, MAX_ROOM_SIZE)
		var x = rng.randi_range(1, GRID_WIDTH - width - 1)
		var y = rng.randi_range(1, GRID_HEIGHT - height - 1)
		
		var new_room = Rect2i(x, y, width, height)
		var overlap = false
		
		for existing_room in rooms:
			if new_room.intersects(existing_room.grow(1)):
				overlap = true
				break
				
		if not overlap:
			carve_room(new_room)
			rooms.append(new_room)

func carve_room(room: Rect2i):
	for x in range(room.position.x, room.end.x + 1):
		for y in range(room.position.y, room.end.y + 1):
			walkable_cells[x][y] = true

func connect_rooms():
	var rng = RandomNumberGenerator.new()
	
	# Connect rooms using minimum spanning tree approach
	var connections = rooms.duplicate()
	connections.shuffle()
	
	for i in range(connections.size() - 1):
		var room1 = connections[i]
		var room2 = connections[i + 1]
		
		var start = Vector2i(
			rng.randi_range(room1.position.x + 1, room1.end.x - 1),
			rng.randi_range(room1.position.y + 1, room1.end.y - 1)
		)
		
		var end = Vector2i(
			rng.randi_range(room2.position.x + 1, room2.end.x - 1),
			rng.randi_range(room2.position.y + 1, room2.end.y - 1)
		)
		
		carve_corridor(start, end)

func carve_corridor(start: Vector2i, end: Vector2i):
	# Horizontal then vertical
	var x_dir = sign(end.x - start.x)
	var y_dir = sign(end.y - start.y)
	
	# Horizontal segment
	for x in range(start.x, end.x + x_dir, x_dir):
		for dx in range(-CORRIDOR_WIDTH, CORRIDOR_WIDTH + 1):
			for dy in range(-CORRIDOR_WIDTH, CORRIDOR_WIDTH + 1):
				var px = x + dx
				var py = start.y + dy
				if is_in_bounds(px, py):
					walkable_cells[px][py] = true
					
	# Vertical segment
	for y in range(start.y, end.y + y_dir, y_dir):
		for dx in range(-CORRIDOR_WIDTH, CORRIDOR_WIDTH + 1):
			for dy in range(-CORRIDOR_WIDTH, CORRIDOR_WIDTH + 1):
				var px = end.x + dx
				var py = y + dy
				if is_in_bounds(px, py):
					walkable_cells[px][py] = true

func is_in_bounds(x: int, y: int) -> bool:
	return x >= 0 && x < GRID_WIDTH && y >= 0 && y < GRID_HEIGHT
