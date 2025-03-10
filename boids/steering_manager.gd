extends Node

var active_behaviors := {}
var deactivated_behaviors := {}
var force_debug_data := {}

func calculate_steering_force(agent: CharacterBody2D) -> Vector2:
	var total_force := Vector2.ZERO
  
	for behavior_name in active_behaviors:
		var behavior = active_behaviors[behavior_name]
		var force = behavior.calculate_force(agent)

		force_debug_data[behavior_name] = {
			"force": force,
			"color": _get_behavior_color(behavior_name),
			"radius": behavior.radius
		}
		total_force += force
  
	return total_force


func add_behavior(behavior_name: String, params: Dictionary = {}) -> void:
	var behavior = load("res://boids/behaviors/%s.gd" % behavior_name).new()
	for key in params:
		behavior.set(key, params[key])
	deactivated_behaviors[behavior_name] = behavior


func toggle_behavior(behavior_name: String, enable: bool) -> void:
	if enable:
		if deactivated_behaviors.has(behavior_name):
			active_behaviors[behavior_name] = deactivated_behaviors[behavior_name]
			deactivated_behaviors.erase(behavior_name)
	else:
		if active_behaviors.has(behavior_name):
			deactivated_behaviors[behavior_name] = active_behaviors[behavior_name]
			active_behaviors.erase(behavior_name)
			force_debug_data.erase(behavior_name)


func _get_behavior_color(behavior_name: String) -> Color:
	match behavior_name:
		"seek": return Color.GREEN
		"flee": return Color.RED
		"wander": return Color.CYAN
		"cohesion": return Color.BLUE
		"separation": return Color.RED
		"aligment": return Color.YELLOW
		_: return Color.WHITE
