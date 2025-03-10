class_name AvoidBehavior extends BaseSteeringBehavior

@export var avoid_strength: float = 500.0
@export var max_force: float = 400.0

var target_position: Vector2
var target_node: Node2D 
	
func calculate_force(agent: CharacterBody2D) -> Vector2:
	var current_target = target_node.global_position if target_node else target_position
	var to_target = agent.global_position - current_target
	var distance = to_target.length()
	
	if distance > radius:
		return Vector2.ZERO
	
	var safe_distance = max(distance, 1.0)
	var force_magnitude = avoid_strength / (safe_distance ** 2)
	var force = to_target.normalized() * min(force_magnitude, max_force)
	
	return force
