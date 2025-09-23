extends CharacterBody2D

# VARIABLES NEEDED
const BASE_SPEED = 100.0
const MAX_SPEED = 400.0
const ACCELERATION_FACTOR = 2.0
var target_position : Vector2
var is_moving : bool = false
var can_move : bool = true

signal movement_blocked

func _input(event):
	if !can_move:
		return
	if (event is InputEventMouseButton and event.pressed) or (event is InputEventScreenTouch and event.pressed):
		target_position = event.position
		is_moving = true

func _physics_process(delta):
	if is_moving:
		var distance = position.distance_to(target_position)
		var dynamic_speed = clamp(BASE_SPEED + distance * ACCELERATION_FACTOR, BASE_SPEED, MAX_SPEED)
		var direction = (target_position - position).normalized()
		var motion = direction * dynamic_speed * delta
		
		var collision = move_and_collide(motion)
		if collision or distance < 5:
			is_moving = false
			emit_signal("movement_blocked")
		elif position.distance_to(target_position) < 5:
			is_moving = false
