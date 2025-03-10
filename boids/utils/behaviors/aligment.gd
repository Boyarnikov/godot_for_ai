class_name AlignmentBehavior extends BaseSteeringBehavior

@export var strength: float = 5

func calculate_force(agent: CharacterBody2D) -> Vector2:
	var neighbors = _find_nearby_agents(agent)
	if neighbors.is_empty():
		return Vector2.ZERO
	
	var avg_velocity := Vector2.ZERO
	for neighbor in neighbors:
		avg_velocity += neighbor['collider'].velocity
	avg_velocity /= neighbors.size()

	return (avg_velocity - agent.velocity).normalized() * strength
