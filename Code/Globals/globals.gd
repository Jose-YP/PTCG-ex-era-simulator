extends Node

#For any node that can bring up the check card display
var checking: bool = false

signal enter_check

func checking_card():
	checking = true
	enter_check.emit()

func reset():
	checking = false
