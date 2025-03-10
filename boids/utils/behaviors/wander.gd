class_name WanderBehavior extends BaseSteeringBehavior

@export var wander_distance: float = 150.0     
@export var wander_jitter: float = 25.0     

var wander_target: Vector2 = Vector2.ZERO

func calculate_force(agent: CharacterBody2D) -> Vector2:
	wander_target += Vector2(
		randf_range(-wander_jitter, wander_jitter),
		randf_range(-wander_jitter, wander_jitter)
	)
	wander_target = wander_target.limit_length(radius)
	
	var forward = agent.velocity.normalized() if agent.velocity.length() > 0 else Vector2.RIGHT
	var circle_center = agent.position + forward * wander_distance
	
	var target_world = circle_center + wander_target
	var desired_velocity = (target_world - agent.position).normalized() * agent.max_speed
	
	return desired_velocity - agent.velocity
