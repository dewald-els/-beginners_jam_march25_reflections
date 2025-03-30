class_name HealthHeart
extends PanelContainer

@onready var heart_texture: TextureRect = %HeartTexture

@export var full_texture: Texture2D
@export var empty_texture: Texture2D

func _ready() -> void:
	heart_texture.texture = full_texture

func set_empty() -> void:
	heart_texture.texture = empty_texture
