extends Node


export var totalPopulation := 100
export var margin := 100
export (PackedScene) var Boid
var screensize : Vector2

func _ready():
	randomize()
	$Player.start($startPosition.position)
	for c in totalPopulation:
		spawnBoid()


func spawnBoid():
	var boid = Boid.instance()
	$Boids.add_child(boid)
	boid.connect("respawn", self, "_on_Boid_respawn")
	#boid.modulate = Color(0, randf(), randf(), 1)
	boid.global_position = Vector2((rand_range(margin, boid.screensize.x - margin)), (rand_range(margin, boid.screensize.y - margin)))
	boid.vel = Vector2(rand_range(-1, 1), rand_range(-1, 1))


func _on_Boid_respawn():
	spawnBoid()
