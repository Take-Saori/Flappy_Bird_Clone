extends CanvasLayer

signal start_game

func update_score(score):
	$ScoreLabel.text = "Score:\n" + str(score)
	
func show_restart_button():
	$RestartButton.show()

func _on_restart_button_pressed():
	$RestartButton.hide()
	start_game.emit()


func hide_start_message():
	$StartMessage.hide()


func hide_restart_button():
	$RestartButton.hide()
