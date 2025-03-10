class_name CohesionBehavior extends BaseSteeringBehavior

@export var cohesion_weight: float = 0.1

func calculate_force(agent: CharacterBody2D) -> Vector2:
	var neighbors = _find_nearby_agents(agent)
	if neighbors.is_empty(): 
		return Vector2.ZERO
	
	var avg_position := Vector2.ZERO
	for neighbor in neighbors:
		avg_position += neighbor['collider'].global_position
	avg_position /= neighbors.size()
	
	var to_avg = avg_position - agent.global_position
	return to_avg.normalized() * agent.max_speed * cohesion_weight
