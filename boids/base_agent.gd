extends CharacterBody2D

@export var mass: float = 0.1
@export var fixed_speed: float = 200.0
@export var max_speed: float = 250.0
var acceleration := Vector2.ZERO

@export var screen_wrapping := true 
var viewport_rect: Rect2

@onready var steering_manager = $SteeringManager

func update_viewport_rect():
	var camera = get_viewport().get_camera_2d()
	if camera:
		viewport_rect = camera.get_viewport_rect()
	else:
		viewport_rect = get_viewport().get_visible_rect()


func _ready():
	get_viewport().connect("size_changed", update_viewport_rect)
	update_viewport_rect()


func _physics_process(delta: float) -> void:
	var steering_force = steering_manager.calculate_steering_force(self)
	acceleration = steering_force / mass
	velocity += acceleration * delta
	velocity = velocity.normalized() * fixed_speed
	move_and_slide()
	
	if screen_wrapping:
		wrap_screen_position()

	if velocity.length() > 0.1:
		$Sprite2D.rotation = velocity.angle()

func wrap_screen_position():
	var new_pos = global_position
	
	if global_position.x > viewport_rect.end.x:
		new_pos.x = viewport_rect.position.x
	elif global_position.x < viewport_rect.position.x:
		new_pos.x = viewport_rect.end.x
		
	if global_position.y > viewport_rect.end.y:
		new_pos.y = viewport_rect.position.y
	elif global_position.y < viewport_rect.position.y:
		new_pos.y = viewport_rect.end.y
	
	global_position = new_pos

@export var debug_areas: bool = false
@export var debug_steering_forces := true
@export var force_scale: float = 1 

func _draw():
	
	var start_pos := Vector2.ZERO
	for behavior_name in steering_manager.force_debug_data:
		var data = steering_manager.force_debug_data[behavior_name]
		var force_vector = data["force"] * force_scale
		if debug_steering_forces:
			draw_line(start_pos, force_vector, data["color"], 2.0)
		if debug_areas and data["radius"] > 0.1:
			draw_arc(Vector2.ZERO, data["radius"], 0, TAU, 36, data["color"], 1.0, true)

func _process(_delta):
	if debug_steering_forces:
		queue_redraw()
