class_name Bot
extends Node

var character: Character
var rival: Character


func _init(character: Character, rival: Character) -> void:
	self.character = character
	self.rival = rival


func process() -> void:
	pass
