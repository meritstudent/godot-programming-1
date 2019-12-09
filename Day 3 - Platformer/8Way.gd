# Author: Kyler Day
# Source: https://github.com/kydy11/godotThing/blob/master/scripts/playerScript.gd
extends KinematicBody2D

const METERS =300;
const GRAVITY =9.8;

var moveSpeed =0.2;
var maxMoveSpeed =2;
var jumpHeight =4;
var jumpTime =1;
var currentJumpTime =0;

var velocity = Vector2()

func _physics_process(delta):
	
	# L/R Movement
	if Input.is_action_pressed("left")&& velocity.y==0:
		velocity.x += -moveSpeed *METERS;
	elif Input.is_action_pressed("right")&& velocity.y==0:
		velocity.x += moveSpeed *METERS;
	elif velocity.x<0:
		if velocity.y!=0:
			# Air resistance
			velocity.x +=0.02 *METERS;
		else:
			# Horizontal Friction
			velocity.x +=0.1 *METERS;
		if velocity.x > -0.02 *METERS:
			velocity.x=0;
	elif velocity.x>0:
		if velocity.y!=0:
			# Air resistance
			velocity.x -=0.02 *METERS;
		else:
			# Horizontal Friction
			velocity.x-=0.1*METERS
		if velocity.x < 0.02 *METERS:
			velocity.x=0;

	# Maximum x direction speed
	if velocity.x>maxMoveSpeed*METERS:
		velocity.x=maxMoveSpeed*METERS
	elif velocity.x<-maxMoveSpeed*METERS:
		velocity.x=-maxMoveSpeed*METERS

	# Jump
	if Input.is_action_just_pressed("up") && velocity.y==0:
		currentJumpTime=jumpTime;
		if Input.is_action_pressed("left"):
			velocity.x += -moveSpeed*jumpHeight *METERS;
			if velocity.x > -maxMoveSpeed *METERS:
				velocity.y += moveSpeed*METERS;
		if Input.is_action_pressed("right"):
			velocity.x += moveSpeed * jumpHeight *METERS;
			if velocity.x < maxMoveSpeed *METERS:
				velocity.y += moveSpeed*METERS;
			
	# Jumping upwards, decrease y velocity slowly
	if currentJumpTime>0:
		velocity.y -= (jumpHeight/jumpTime) *currentJumpTime *METERS;
		currentJumpTime-=1;
	
	# Falling velocity
	velocity.y += delta * GRAVITY * METERS;
	
	# Reset the velocity after collisions
	if move_and_slide(velocity/2)[1]==0:
		velocity.y =0;
	if move_and_slide(velocity/2)[0]==0:
		if velocity.x >0:
			velocity.x = 0.05 *METERS;
		elif velocity.x <0:
			velocity.x = -0.05 *METERS;
		elif velocity.x == 0:
			velocity.x = 0