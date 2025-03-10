@tool
class_name UtilityConsideration
extends Resource

@export var input_axis: StringName = ""
@export var min_value: float = 0.0  
@export var max_value: float = 1.0
@export var response_curve: Curve 

func calculate_score(context) -> float:
	var raw_value: float = 0.0
	if context.has_method(input_axis):
		raw_value = context.call(input_axis) 
	else:
		if input_axis in context:
			raw_value = context.get(input_axis)
	var normalized = (raw_value - min_value) / (max_value - min_value)
	normalized = clamp(normalized, 0.0, 1.0)

	if response_curve:
		return clamp(response_curve.sample(normalized), 0.0, 1.0)
	else:
		return normalized
