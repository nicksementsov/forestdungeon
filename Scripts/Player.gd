extends CharacterBody2D

@export var speed = 95
# var velocity = Vector2.ZERO
var idle = true
var busy = false
var attacking = false
var attack_timer = 0.0

var attack_times = [0.25]

var state = -1

var direction = 2 # 0:north, 1:east, 2:south, 3:west
var direction_postfixes = [
	"_north",
	"_east",
	"_south",
	"_east"
]
var check_box_transforms = [
	Vector2(0, -15),
	Vector2(15, 0),
	Vector2(0, 30),
	Vector2(-15, 0),
]
var check_box

var health = 3
var max_health = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	check_box = $CheckCollider
	self.hide()

func spawn(loc):
	self.position.x = loc.x
	self.position.y = loc.y
	self.state = 0
	self.direction = 2
	update_colliders()
	self.show()

func despawn():
	state = -1
	direction = 2
	update_colliders()
	self.hide()

func get_input():
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_select"):
		if not attacking:
			attacking = true

func get_animation():
	$AnimatedSprite2D.play()
	if velocity.length() > 0 and state == 0:
		idle = false
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walk_east"
			if velocity.x < 0:
				direction = 3
				$AnimatedSprite2D.flip_h = true
			else:
				direction = 1
				$AnimatedSprite2D.flip_h = false
		elif velocity.y < 0:
			$AnimatedSprite2D.animation = "walk_north"
			direction = 0
		elif velocity.y > 0:
			$AnimatedSprite2D.animation = "walk_south"
			direction = 2
		update_colliders()
	elif state == 1:
		idle = false
		if direction == 3:
			$AnimatedSprite2D.flip_h = true
		elif direction == 2:
			$AnimatedSprite2D.animation = "attack_south"
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		if not idle:
			idle = true
			$AnimatedSprite2D.animation = "idle" + direction_postfixes[direction]
			$AnimatedSprite2D.pause()

func update_colliders():
	check_box.transform.origin = check_box_transforms[direction]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state == -1:
		return
	velocity = Vector2.ZERO
	get_input()
	velocity = velocity.normalized() * speed
	if attacking and state == 0:
		state = 1
		attacking = false
		attack_timer = 0.0
	if state == 1:
		attacking = false
		attack_timer += delta
		velocity = Vector2(0, 0)
		if attack_timer >= attack_times[0]:
			state = 0
			
	get_animation()
	set_velocity(velocity)
	move_and_slide() 

func take_damage(amount):
	health -= amount
	if health < 0:
		health = 0
	elif health > max_health:
		health = max_health
