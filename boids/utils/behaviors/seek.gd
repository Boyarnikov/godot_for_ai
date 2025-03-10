class_name SeekBehavior extends BaseSteeringBehavior

var target_node: Node2D
var target_position: Vector2
var strength: float = 0.1

func calculate_force(agent: CharacterBody2D) -> Vector2:
	var current_target = target_node.global_position if target_node else target_position
	var desired_velocity = (current_target - agent.global_position).normalized() * agent.max_speed * strength
	
	return desired_velocity - agent.velocity
