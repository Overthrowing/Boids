extends RigidBody2D

signal hit


export var speed = 3  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
onready var Vision := $Vision.get_children()

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(_delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		rotation = lerp_angle(rotation, velocity.angle_to_point(Vector2.ZERO), 0.4)
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		rotation = lerp_angle(rotation, velocity.angle_to_point(Vector2.ZERO), 0.4)
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		rotation = lerp_angle(rotation, velocity.angle_to_point(Vector2.ZERO), 0.4)
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		rotation = lerp_angle(rotation, velocity.angle_to_point(Vector2.ZERO), 0.4)

	for r in Vision:
		var ray : RayCast2D = r
		if ray.is_colliding() and ray.get_collider().is_in_group("tiles"):
			if (ray.get_collision_point() - global_position).length_squared() != 0:
				var magi = (100/(ray.get_collision_point() - global_position).length_squared())
				velocity -= (ray.cast_to.rotated(rotation) * magi)
				rotation = lerp_angle(rotation, velocity.angle_to_point(Vector2.ZERO), 0.4)

	velocity = velocity.normalized() * speed


	global_position += velocity
	global_position.x = clamp(global_position.x, 0, screen_size.x)
	global_position.y = clamp(global_position.y, 0, screen_size.y)

func start(pos):
	position = pos
	show()

