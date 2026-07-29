package snake

import rl "vendor:raylib"

main :: proc() {
	assets := init()

	for !rl.WindowShouldClose() {
		gm = .Menu
		menu_picker()

		#partial switch gm {
		case .SinglePlayer:
			run_single_player(assets)
		case .DoublePlayer:
			run_double_player(assets)
		}
	}

	cleanup(assets)
	close_game()
}
