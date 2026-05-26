class_name GameView extends Control

var gold_text: String = "Gold: " 
var gold_val: float = 0.0
@export var gold_label: Label

func _process(_delta: float) -> void:
	update_resources()

func update_resources():
	gold_label.text = gold_text + str(gold_val)
