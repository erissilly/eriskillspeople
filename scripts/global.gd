extends Node

signal attacked(target: Enemy)

var level = 1
var enemydead = 0

var player : Player

func reset_game():
	level = 1
	enemydead = 0 
