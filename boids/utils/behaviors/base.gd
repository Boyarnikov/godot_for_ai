class_name BaseSteeringBehavior extends Node

@export var radius: float = 0

func calculate_force(_agent: CharacterBody2D) -> Vector2:
	return Vector2.ZERO

func _find_nearby_agents(agent: CharacterBody2D) -> Array:
	if radius < 0.01:
		return []
	
	var space = agent.get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = CircleShape2D.new()
	query.shape.radius = radius
	query.transform = agent.global_transform
	query.collision_mask = 1 << 0 
	
	return space.intersect_shape(query).filter(
		func(result): return result.collider != agent
	)
