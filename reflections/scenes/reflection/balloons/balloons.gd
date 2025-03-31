class_name Balloons
extends RigidBody2D

var balloons: Array[Balloon] = []

const MAX_BALLOONS: int = 5
var active_balloons: int = MAX_BALLOONS

func _ready() -> void:
	for balloon in get_children():
		if balloon is RigidBody2D:
			var joint = DampedSpringJoint2D.new()
			joint.node_a = self.get_path()
			joint.node_b = balloon.get_path()
			joint.rest_length = 10
			joint.stiffness = 50
			joint.damping = 1 
			add_child(joint)
			balloons.append(balloon)
	
	SignalBus.incorrect_input.connect(_on_incorrect_input)

func pop_balloon() -> void:
	if active_balloons > 0:
		active_balloons -= 1
		var balloon_to_pop: Balloon = balloons.pop_back()
		if balloon_to_pop:
			balloon_to_pop.pop()
	
		if active_balloons == 0:
			restore_gravity()
		

func restore_gravity() -> void:
	gravity_scale = 1
		
func _on_incorrect_input() -> void:
	pop_balloon()
		
		
		
