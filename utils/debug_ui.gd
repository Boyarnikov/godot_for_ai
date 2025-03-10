extends Control

@export var agent: NodePath
@export var tracked_properties: Array[String]

@onready var _label: Label = $Label

func _ready():
	if not get_node(agent):
		push_error("DebugUI: No agent assigned!")
		set_process(false)

func _process(_delta):
	var agent_node = get_node(agent)
	var text = ""
	
	for prop in tracked_properties:
		if prop in agent_node:
			var value = agent_node.get(prop)
			text += "%s: %.1f\n" % [prop, value]
		else:
			text += "%s: N/A\n" % prop
	text += "state: " + agent_node.get("state")
	_label.text = text
