class_name MainMenu
extends CanvasLayer

@export var main_game_scene: PackedScene


@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(main_game_scene)


func _on_quit_pressed() -> void:
	pass
