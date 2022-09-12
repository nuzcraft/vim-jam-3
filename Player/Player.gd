extends KinematicBody2D
class_name Player

export(int) var JUMP_VELOCITY = 250
export(int) var JUMP_RELEASE_VELOCITY = 120
export(int) var DOUBLE_JUMP_COUNT = 0
export(int) var ACCELERATION = 150
export(float) var ACCELERATION_DAMPING = 0.12
export(int) var FRICTION = 800
export(int) var GRAVITY = 800
export(int) var EXTRA_GRAVITY = 300
export(int) var MAX_GRAVITY = 1200

enum {
	MOVE
}

var velocity = Vector2.ZERO
var state = MOVE
var double_jump = DOUBLE_JUMP_COUNT
var buffered_jump = false
var coyote_jump = false
var ring_on = false

onready var animatedSprite := $AnimatedSprite
onready var jumpBufferTimer := $JumpBufferTimer
onready var coyoteJumpTimer := $CoyoteJumpTimer
onready var liquidCollisionArea2D := $LiquidCollisionArea2D
onready var ringSprite := $Ringsprite
onready var ringSpriteAnimationPlayer := $Ringsprite/AnimationPlayer

func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	if Input.is_action_just_pressed("restart_game"):
		Events.emit_signal("restart_game")
		
	if Input.is_action_just_pressed("ui_accept"):
		if not ring_on:
			ring_on	= true
			ringSpriteAnimationPlayer.play("put on")
			Events.emit_signal("ring_on")
			animatedSprite.modulate = Color(1, 1, 1.2)
		else:
			ring_on = false
			ringSpriteAnimationPlayer.play("take off")
			Events.emit_signal("ring_off")
			animatedSprite.modulate = Color(1, 1, 1)
	
	match state:
		MOVE: move_state(input, delta)
	
func move_state(input, delta):
	apply_gravity(delta)
	
	if input.x == 0:
		apply_friction(delta)
		if is_on_floor():
			animatedSprite.animation = "idle"
	if input.x != 0:
		apply_acceleration(input, delta)
		animatedSprite.flip_h = input.x > 0
		if is_on_floor():
			animatedSprite.animation = "running"
		
	if is_on_floor():
		double_jump = DOUBLE_JUMP_COUNT
		
	if is_on_floor() or coyote_jump:
		if Input.is_action_just_pressed("ui_up") or buffered_jump:
			velocity.y = -JUMP_VELOCITY
			buffered_jump = false
		
	if not is_on_floor():
		animatedSprite.animation = "jump"
		if Input.is_action_just_released("ui_up") and velocity.y < -JUMP_RELEASE_VELOCITY:
			velocity.y = -JUMP_RELEASE_VELOCITY

		if velocity.y > 0:
			velocity.y += EXTRA_GRAVITY * delta
			
		if Input.is_action_just_pressed("ui_up") and double_jump > 0:
			velocity.y = -JUMP_VELOCITY
			double_jump -= 1
			
		if Input.is_action_just_pressed("ui_up"):
			buffered_jump = true
			jumpBufferTimer.start()
	
	var was_on_floor = is_on_floor()	
	velocity = move_and_slide(velocity, Vector2.UP)
	if was_on_floor and not is_on_floor() and velocity.y > 0:
		coyote_jump = true
		coyoteJumpTimer.start()
	
func apply_gravity(delta):
	velocity.y += GRAVITY * delta
	velocity.y = min(velocity.y, MAX_GRAVITY)
	
func apply_acceleration(input, delta):
	velocity.x += ACCELERATION * delta * input.x
	velocity.x *= pow(1-ACCELERATION_DAMPING, delta*10)
	
func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
func _on_JumpBufferTimer_timeout():
	buffered_jump = false

func _on_CoyoteJumpTimer_timeout():
	coyote_jump = false

func _on_LiquidCollisionArea2D_body_entered(body):
	Events.emit_signal("restart_game")
