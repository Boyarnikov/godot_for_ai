@tool
class_name UtilityReasoner
extends Node

@export var actions: Array[UtilityAction] = []
@export var update_interval: float = 0.5 
@export var auto_decide: bool = true

var _timer: float = 0.0

func _ready() -> void:
	if not Engine.is_editor_hint() and auto_decide:
		set_process(true)
	else:
		set_process(false)

func _process(delta: float) -> void:
	if update_interval > 0:
		_timer += delta
		if _timer < update_interval:
			return
		_timer = 0.0

	decide(get_parent()) 

func decide(context: Object) -> UtilityAction:
	if actions.is_empty() or not context:
		push_warning("UtilityReasoner: No actions or context!")
		return null
	
	var best_action: UtilityAction = null
	var highest_score: float = -INF
	
	for action in actions:
		if not action is UtilityAction:
			continue
		
		var score = action.calculate_utility(context)
		print(str(score) + ": " + action.action_name)
		if score > highest_score:
			highest_score = score
			best_action = action
	
	if best_action:
		_execute_action(best_action, context)
		return best_action
	return null

func _execute_action(action: UtilityAction, context: Object) -> void:
	if action.execute_method.is_empty():
		return
	
	if context.has_method(action.execute_method):
		context.call(action.execute_method)
	else:
		push_error("UtilityReasoner: Method '%s' not found in %s!" % [
			action.execute_method, context.name]
		)
