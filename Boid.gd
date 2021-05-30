extends Area2D


onready var Vision := $Vision.get_children()
var vel = Vector2.ZERO
var speed = 3.0 #7 when scale is 1
var screensize : Vector2
var localGroup = []
var movv = 23 #48

signal respawn


func _ready():
	screensize = get_viewport_rect().size
	randomize()

func _physics_process(_delta):
	boids()
	checkCollision()
	vel = vel.normalized() * speed
	move()
	rotation = lerp_angle(rotation, vel.angle_to_point(Vector2.ZERO), 0.4)

func boids():
	if localGroup:
		var population = localGroup.size()
		var avgVel = Vector2.ZERO
		var avgPos = Vector2.ZERO
		var steerAway = Vector2.ZERO
		for boid in localGroup:
			avgVel += boid.vel
			avgPos += boid.position
			if boid.global_position == global_position:
				pass
			else:
				steerAway -= (boid.global_position - global_position) * (movv/( global_position - boid.global_position).length())

		avgVel /= population
		avgPos /= population
		steerAway /= population

		vel += (avgVel - vel)/2
		vel += (avgPos - position)
		vel += (steerAway)



func checkCollision():
	for r in Vision:
		var ray : RayCast2D = r
		if ray.is_colliding():
			if ray.get_collider().is_in_group("tiles") or ray.get_collider().is_in_group("player"): 
				if (ray.get_collision_point() - global_position).length_squared() != 0:
					var magi = (100/(ray.get_collision_point() - global_position).length_squared())
					vel -= (ray.cast_to.rotated(rotation) * magi)




func move() -> void:
	global_position += vel
	if global_position.x < 0:
		global_position.x = screensize.x 
	if global_position.x > screensize.x:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = screensize.y 
	if global_position.y > screensize.y:
		global_position.y = 0


func _on_Perception_area_entered(area: Area2D):
	if area != self and area.is_in_group("boid"):
		localGroup.append(area)


func _on_Perception_area_exited(area):
	if area:
		localGroup.erase(area)


func _on_Boid_body_entered(body):
	queue_free()
	emit_signal("respawn")
