class_name SeparationBehavior extends BaseSteeringBehavior

@export var separation_force: float
func calculate_force(agent: CharacterBody2D) -> Vector2:
	var force := Vector2.ZERO
	
	var neighbors = _find_nearby_agents(agent)
	
	for neighbor in neighbors:
		var other_agent = neighbor['collider']

		var to_agent = agent.global_position - other_agent.global_position
		var distance = to_agent.length()
		
		if distance < 0.001:
			force += Vector2.UP.rotated(randf_range(0, TAU)) * separation_force
		else:
			var strength = separation_force * (1.0 - (distance / radius) ** 2)
			force += to_agent.normalized() * strength
	
	return force

func _find_nearby_agents(agent: CharacterBody2D) -> Array:
	var space = agent.get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = CircleShape2D.new()
	query.shape.radius = radius
	query.transform = agent.global_transform
	query.collision_mask = 1 << 0 
	
	return space.intersect_shape(query).filter(
		func(result): return result.collider != agent
	)
