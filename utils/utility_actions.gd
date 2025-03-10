@tool
class_name UtilityAction
extends Resource

@export var action_name: String = "New Action"
@export var considerations: Array[UtilityConsideration] = []
@export var weights: Array[float] = []
@export var const_add: float = 0.0
@export var aggregation_type: AggregationType = AggregationType.WEIGHTED_SUM


@export var execute_method: StringName = "" 

enum AggregationType {
	WEIGHTED_SUM,
	MULTIPLICATIVE,
	HIGHEST,
}

func calculate_utility(context: Object) -> float:
	if considerations.is_empty():
		return 0.0
	
	var scores: Array[float] = []
	for c in considerations:
		scores.append(c.calculate_score(context))
	
	match aggregation_type:
		AggregationType.WEIGHTED_SUM:
			var total: float = 0.0
			for i in scores.size():
				total += scores[i] * weights[i]
			return total + const_add
		AggregationType.MULTIPLICATIVE:
			var total: float = 1.0
			for score in scores:
				total *= score
			return total + const_add
		AggregationType.HIGHEST:
			return scores.max() + const_add
		_:
			return 0.0
