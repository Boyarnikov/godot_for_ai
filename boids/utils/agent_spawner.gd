extends Node2D

@export var agent_scene: PackedScene 
@export var spawn_count: int = 50
@export var spawn_grid_columns: int = 10 
@export var spawn_spacing: float = 50.0

@onready var target = $Target 

func _ready():
	create_behavior_ui()
	spawn_agents()

func spawn_agents():
	for i in spawn_count:
		var row = i / spawn_grid_columns
		var col = i % spawn_grid_columns
		var spawn_position = Vector2(
			col * spawn_spacing + 200,
			row * spawn_spacing + 200
		)
		
		# Instance agent and configure
		var agent = agent_scene.instantiate()
		print("Spawner global position: ", global_position)
		print("Target global position: ", target.global_position)
		agent.position = spawn_position + global_position
		add_child(agent)
		
		
		agent.steering_manager.add_behavior(
			"seek", 
			{"target_node": target, "strength": 0.9}
		)
		agent.steering_manager.add_behavior(
			"avoid", 
			{"target_node": target, "avoid_strength": 1080000.0, "radius": 400.0}
		)
		agent.steering_manager.add_behavior(
			"separation",
			{"separation_force": 200.0, "radius": 50.0}
		)
		agent.steering_manager.add_behavior(
			"cohesion",
			{"radius": 100.0}
		)
		agent.steering_manager.add_behavior(
			"aligment",
			{"radius": 200.0, "strength": 10}
		)
		agent.steering_manager.add_behavior(
			"wander",
			{"radius": 200.0, "wander_distance": 100, "wander_jitter": 10}
		)
		
var ui_panel: PanelContainer
var checkboxes := {}

func create_behavior_ui():
	ui_panel = PanelContainer.new()
	ui_panel.anchor_left = 0.0
	ui_panel.anchor_top = 0.0
	ui_panel.position = Vector2(20, 20)
	add_child(ui_panel)
	
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.1, 0.1, 0.1, 0.7)
	panel_style.border_width_bottom = 2
	panel_style.border_color = Color(0.3, 0.3, 0.3)
	ui_panel.add_theme_stylebox_override("panel", panel_style)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 5)
	ui_panel.add_child(vbox)
	
	# Define behaviors to create
	var behaviors = [
		{ "name": "seek", "label": "Seek", "color": Color.LIME_GREEN },
		{ "name": "aligment", "label": "Aligment", "color": Color.ROYAL_BLUE },
		{ "name": "separation", "label": "Separation", "color": Color.ORANGE_RED },
		{ "name": "cohesion", "label": "Cohesion", "color": Color.MEDIUM_PURPLE },
		{ "name": "avoid", "label": "Avoid", "color": Color.MEDIUM_PURPLE },
		{ "name": "wander", "label": "Wander", "color": Color.MEDIUM_PURPLE },
	]
	
	for behavior in behaviors:
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 10)
		
		var checkbox = CheckBox.new()
		checkbox.text = " "
		checkbox.add_theme_color_override("checked_color", behavior["color"])
		checkbox.toggled.connect(_on_behavior_toggled.bind(behavior["name"]))
		
		var label = Label.new()
		label.text = behavior["label"]
		label.add_theme_color_override("font_color", Color.WHITE)
		
		hbox.add_child(checkbox)
		hbox.add_child(label)
		vbox.add_child(hbox)
		
		checkboxes[behavior["name"]] = checkbox

func _on_behavior_toggled(toggled: bool, behavior_name: String):
	for agent in get_children().filter(func(c): return c is CharacterBody2D):
		agent.steering_manager.toggle_behavior(behavior_name, toggled)
