package snake

import rl "vendor:raylib"

WINDOWS_SIZE :: 700
GRID_WIDTH :: 20
CELL_SIZE :: 16
CANVAS_SIZE :: GRID_WIDTH * CELL_SIZE
TICK_RATE :: 0.13
Vec2i :: [2]int
MAX_SNAKE_LENGTH :: GRID_WIDTH * GRID_WIDTH

snake: [MAX_SNAKE_LENGTH]Vec2i
snake_lenght: int
tick_timer: f32 = TICK_RATE
move_direction: Vec2i
game_over: bool

restart :: proc() {
	start_head_pos := Vec2i{GRID_WIDTH / 2, GRID_WIDTH / 2}
	snake[0] = start_head_pos
	snake[1] = start_head_pos - {0, 1}
	snake[2] = start_head_pos - {0, 2}
	snake_lenght = 3
	game_over = false
}


main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOWS_SIZE, WINDOWS_SIZE, "Snake")

	restart()
	move_direction = {0, 1}

	for !rl.WindowShouldClose() {
		switch {
		case rl.IsKeyDown(.UP) || rl.IsKeyDown(.W):
			move_direction = {0, -1}

		case rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S):
			move_direction = {0, 1}

		case rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D):
			move_direction = {1, 0}

		case rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A):
			move_direction = {-1, 0}
		}

		if game_over {

			if rl.IsKeyPressed(.ENTER) {
				restart()
			}

		} else {
			tick_timer -= rl.GetFrameTime()
		}

		if tick_timer <= 0 {
			next_part_pos := snake[0]
			snake[0] += move_direction
			head_pos := snake[0]

			if head_pos.x < 0 ||
			   head_pos.y < 0 ||
			   head_pos.x >= GRID_WIDTH ||
			   head_pos.y >= GRID_WIDTH {
				game_over = true
			}

			for i in 1 ..< snake_lenght {
				cur_pos := snake[i]
				snake[i] = next_part_pos
				next_part_pos = cur_pos
			}
			tick_timer = TICK_RATE + tick_timer
		}

		rl.BeginDrawing()
		rl.ClearBackground({76, 53, 83, 255})

		camera := rl.Camera2D {
			zoom = f32(WINDOWS_SIZE) / CANVAS_SIZE,
		}
		rl.BeginMode2D(camera)

		for i in 0 ..< snake_lenght {
			head_rect := rl.Rectangle {
				f32(snake[i].x) * CELL_SIZE,
				f32(snake[i].y) * CELL_SIZE,
				CELL_SIZE,
				CELL_SIZE,
			}
			rl.DrawRectangleRec(head_rect, rl.WHITE)
		}

		if game_over {
			rl.DrawText("Game Over!", 4, 4, 25, rl.RED)
			rl.DrawText("Press Enter to play again", 4, 30, 15, rl.BLACK)
		}

		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
