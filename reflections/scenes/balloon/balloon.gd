@tool
class_name Balloon
extends RigidBody2D


@onready var sprite_2d: Sprite2D = %Sprite2D


@export var pink_balloon: Texture2D
@export var blue_balloon: Texture2D
@export var yellow_balloon: Texture2D
@export var red_balloon: Texture2D
@export var purple_balloon: Texture2D

enum BalloonColour {
	Pink,
	Blue,
	Yellow,
	Red,
	Purple
}

@export var balloon_colour: BalloonColour 

func _ready() -> void:
	mass = 1.0  # Make balloons naturally rise
	
	match (balloon_colour):
		BalloonColour.Pink:
			sprite_2d.texture = pink_balloon
		BalloonColour.Blue:
			sprite_2d.texture = blue_balloon
		BalloonColour.Yellow:
			sprite_2d.texture = yellow_balloon
		BalloonColour.Red:
			sprite_2d.texture = red_balloon
		BalloonColour.Purple:
			sprite_2d.texture = purple_balloon

func _physics_process(delta):
	apply_central_force(Vector2(0, -mass * 500))  # Lift force

func pop() -> void:
	Callable(queue_free).call_deferred()
