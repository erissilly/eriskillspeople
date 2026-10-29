extends Node

signal attacked(target: Enemy)
signal sawplayer

var level = 1
var enemydead = 0

var player : Player
var can_open_options := true
var firsttimeplaying = true
var current_room: Node = null

func reset_game():
	level = 1
	enemydead = 0
	firsttimeplaying = true
	current_room = null
