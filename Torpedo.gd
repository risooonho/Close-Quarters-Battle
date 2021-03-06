extends Node2D

var value = 0
var value2 = 0
var counter = 30
var direction = 0
var direction2 = 0
var scaler = 0
var scaler2 = 0
var speed = 300
var speed2 = 0
var step = 0

var t
var lastloc = Vector2()
var newloc = Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var frame
var firer
var angle_to_target

# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(false)
	t = get_tree().get_nodes_in_group("level_timer")[0]
	rotate_to_target()
	

func setup(fired,origin,target):
	set_as_toplevel(true)
	firer = fired
	#var adjust_origin = Vector2(origin.x + (globals.cellsize / 2), origin.y + (globals.cellsize / 2))
	#var adjust_target = Vector2(target.x + (globals.cellsize / 2), target.y + (globals.cellsize / 2))
	
	lastloc = firer.get_node("Sprite").get_global_position()
	print(target)
	newloc = target.get_node("Position2D").get_global_position()
	print("torpedo added: ", target, origin, fired)
	

	set_global_position(lastloc)

func rotate_to_target():
	var angle = get_global_position().angle_to_point(newloc)
	
	#set_rotation_degrees(rotate)
	
	angle_to_target = -Vector2(cos(angle), sin(angle))

func move_forward(delta):
	#set_as_toplevel(true)
	var frame = t.get_time_left() / t.get_wait_time() 
	frame = 1 - frame
	if frame >= 1:
		#set_global_position(newloc)
		globals.firing = false
		#queue_free()
	else:
		set_visible(true)
		#step = 1
		var pos = get_global_position()
		pos = pos + (angle_to_target * (speed * delta))
		set_global_position(pos) 


func move(delta):
	#set_as_toplevel(true)
	var frame = t.get_time_left() / t.get_wait_time() 
	frame = 1 - frame
	if frame >= 1:
		set_global_position(newloc)
		globals.firing = false
		queue_free()
	else:
		var current = lastloc.linear_interpolate(newloc,frame)
		set_global_position(current)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#rotate_to_target()
	
	if globals.state == "idle":
		queue_free()

	
	frame = t.get_time_left() / t.get_wait_time() 
	#move(delta)
	move_forward(delta)

func impact():
	$splode.play()
	if has_node("Node2D"):
		$Node2D.queue_free()

func hit(damage):
	impact()

func _on_Area2D_area_entered(area):
	if area == firer.get_node("Sprite/hit_box"):
		pass
	else:
		print("torpedo hit!")
		if firer.sensor == 2:
			area.hit(100)
			firer.sensor = 0
		else:
			area.hit(50)
		impact()

#func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
#	if frame < 0.9:
#		print("torpedo hit! at: ", frame)
#		area.hit(50)
#		queue_free()
	#pass # Replace with function body.


func _on_splode_finished():
	queue_free()
	pass # Replace with function body.
