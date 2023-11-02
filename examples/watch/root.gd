extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	watch(delta)
	
	watch(Color.AQUA)
	
	watch(delta * 10)
