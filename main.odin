package snake

import rl "vendor:raylib"

main :: proc() {
	init()

	for !rl.WindowShouldClose() {
		gm = .Menu
		menu_picker()

		#partial switch gm {
		case .SinglePlayer:
			run_single_player()
		case .DoublePlayer:
		// run_double_player()
		}
	}

	close_game()
}
