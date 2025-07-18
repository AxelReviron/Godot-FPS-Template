extends Node

#region Game Features
var CAN_DOUBLE_JUMP: bool = false
#endregion

#region Player
var PLAYER_SPEED: float = 5.0
var PLAYER_SPRINT_SPEED: float = 8.0
var PLAYER_CROUCH_SPEED: float = 3.0

var PLAYER_JUMP_VELOCITY: float = 4.5
var PLAYER_JUMP_INPUT_MULTIPLIER: float = 0.85

var PLAYER_ACCELERATION: float = 0.1
var PLAYER_DECELERATION: float = 0.25

# States Animations
var MAX_PLAYER_WALKING_ANIM_SPEED: float = 2.2
var MAX_PLAYER_SPRINTING_ANIM_SPEED: float = 2.2
var MAX_PLAYER_SLIDING_ANIM_SPEED: float = 4.0

var PLAYER_SLID_TILT_AMOUNT: float = 0.09
#endregion

#region Weapon
var WEAPON_CROUCHING_BOB_SPEED: float = 5.0
var WEAPON_CROUCHING_BOB_H_AMOUNT: float = 2.0 # Horizontal bob amount
var WEAPON_CROUCHING_BOB_V_AMOUNT: float = 0.5 # Vertical bob amount

var WEAPON_WALKING_BOB_SPEED: float = 7.0
var WEAPON_WALKING_BOB_H_AMOUNT: float = 4.0 # Horizontal bob amount
var WEAPON_WALKING_BOB_V_AMOUNT: float = 1.0 # Vertical bob amount

var WEAPON_SPRINTING_BOB_SPEED: float = 9.0
var WEAPON_SPRINTING_BOB_H_AMOUNT: float = 8.0 # Horizontal bob amount
var WEAPON_SPRINTING_BOB_V_AMOUNT: float = 2.0 # Vertical bob amount
#endregion

#region Interaction
var INTERACT_DISTANCE: float = 2.0
#endregion
