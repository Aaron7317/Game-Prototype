extends Node2D

# THIS HAS BASIC PROPERTIES FOR A CELL
@export var tile_id : int = -1 # Subject to change where I put this
@export var spawn_probability : float = 1.0 # The probability this tile will actually be placed given an attempted place 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
