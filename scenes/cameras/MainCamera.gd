extends Camera2D

@export var x_speed : int = 20 
@export var y_speed : int = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# TODO: EMIT SIGNALS ON MOVING
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		translate(Vector2(0, -y_speed))
	if Input.is_action_pressed("ui_down"):
		translate(Vector2(0, y_speed))	
	if Input.is_action_pressed("ui_right"):
		translate(Vector2(x_speed, 0))	
	if Input.is_action_pressed("ui_left"):
		translate(Vector2(-x_speed, 0))		
	
