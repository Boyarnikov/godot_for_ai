extends Node2D
class_name AntAgent

@export var hunger: float = 30.0: set = _set_hunger
@export var energy: float = 50.0: set = _set_energy
@export var distance_to_food: float = 100.0

var state: String = "None"

func _set_hunger(value: float) -> void:
	hunger = clamp(value, 0.0, 100.0)
	
func _set_energy(value: float) -> void:
	energy = clamp(value, 0.0, 100.0)

func _process(delta: float) -> void:
	hunger += delta
	energy -= delta

func seek_food() -> void:
	print("Getting closer to food...")
	state = "Finding food"
	distance_to_food -= randf_range(0.5, 5)
	distance_to_food = clamp(distance_to_food, 0.0, 500.0)

func forage() -> void:
	print("Foraging for food...")
	state = "Foraging"
	hunger -= 6
	if randi() % 10 == 0:
		distance_to_food = randf_range(100.0, 120.0)
	hunger = clamp(hunger, 0.0, 100.0)

func rest() -> void:
	print("Resting...")
	state = "Resting"
	energy += 4
	energy = clamp(energy, 0.0, 100.0)
