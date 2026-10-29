extends Node

signal attacked(target: Enemy)
signal sawplayer

var level = 1
var enemydead = 0

var player : Player
var can_open_options := true
var firsttimeplaying = true
var current_room: Node = null
var DURATIONTOTILE: float = 0.3

func reset_game():
	level = 1
	enemydead = 0
	firsttimeplaying = true
	current_room = null
	DURATIONTOTILE = 0.3
