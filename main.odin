package snake

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WINDOWS_SIZE :: 900
GRID_WIDTH :: 20
CELL_SIZE :: 16
CANVAS_SIZE :: GRID_WIDTH * CELL_SIZE
TICK_RATE :: 0.13
Vec2i :: [2]int
MAX_SNAKE_LENGTH :: GRID_WIDTH * GRID_WIDTH

snake: [MAX_SNAKE_LENGTH]Vec2i
snake_length: int
tick_timer: f32 = TICK_RATE
direction_changed_this_tick: bool
move_direction: Vec2i
game_over: bool
food_pos: Vec2i

restart :: proc() {
	start_head_pos := Vec2i{GRID_WIDTH / 2, GRID_WIDTH / 2}
	snake[0] = start_head_pos
	snake[1] = start_head_pos - {0, 1}
	snake[2] = start_head_pos - {0, 2}
	snake_length = 3
	game_over = false
	random_food()
	move_direction = {0, 1}

}

random_food :: proc() {
	occupied: [GRID_WIDTH][GRID_WIDTH]bool

	for i in 0 ..< snake_length {
		occupied[snake[i].x][snake[i].y] = true
	}

	free_cells := make([dynamic]Vec2i, context.temp_allocator)

	for x in 0 ..< GRID_WIDTH {
		for y in 0 ..< GRID_WIDTH {
			if !occupied[x][y] {
				append(&free_cells, Vec2i{x, y})
			}
		}
	}

	if len(free_cells) > 0 {
		random_cell_index := rl.GetRandomValue(0, i32(len(free_cells) - 1))
		food_pos = free_cells[random_cell_index]
	}
}

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOWS_SIZE, WINDOWS_SIZE, "Snake")
	rl.InitAudioDevice()

	restart()

	high_score := 0
	food_sprite := rl.LoadTexture("food.png")
	snake_head_sprite := rl.LoadTexture("snake_head.png")
	snake_tail_sprite := rl.LoadTexture("snake_tail.png")
	snake_body_sprite := rl.LoadTexture("snake_body.png")

	eat_sound := rl.LoadSound("eat.wav")
	crash_sound := rl.LoadSound("crash.wav")

	for !rl.WindowShouldClose() {
		if !direction_changed_this_tick {
			switch {
			case rl.IsKeyPressed(.UP) && move_direction != {0, 1}:
				move_direction = {0, -1}
				direction_changed_this_tick = true

			case rl.IsKeyPressed(.DOWN) && move_direction != {0, -1}:
				move_direction = {0, 1}
				direction_changed_this_tick = true

			case rl.IsKeyPressed(.RIGHT) && move_direction != {-1, 0}:
				move_direction = {1, 0}
				direction_changed_this_tick = true

			case rl.IsKeyPressed(.LEFT) && move_direction != {1, 0}:
				move_direction = {-1, 0}
				direction_changed_this_tick = true
			}
		}; if game_over {

			if rl.IsKeyPressed(.ENTER) {
				restart()
			}

		} else {
			tick_timer -= rl.GetFrameTime()
		}

		if tick_timer <= 0 {
			next_part_pos := snake[0]
			snake[0] += move_direction
			direction_changed_this_tick = false
			head_pos := snake[0]

			if head_pos.x < 0 ||
			   head_pos.y < 0 ||
			   head_pos.x >= GRID_WIDTH ||
			   head_pos.y >= GRID_WIDTH {
				game_over = true
				rl.PlaySound(crash_sound)
			}

			for i in 1 ..< snake_length {
				cur_pos := snake[i]

				if cur_pos == head_pos {
					game_over = true
					rl.PlaySound(crash_sound)
				}

				snake[i] = next_part_pos
				next_part_pos = cur_pos
			}

			if head_pos == food_pos {
				snake_length += 1
				snake[snake_length - 1] = next_part_pos
				random_food()
				rl.PlaySound(eat_sound)
			}

			tick_timer = TICK_RATE + tick_timer
		}

		rl.BeginDrawing()
		rl.ClearBackground({45, 52, 70, 255})


		camera := rl.Camera2D {
			zoom = f32(WINDOWS_SIZE) / CANVAS_SIZE,
		}
		rl.BeginMode2D(camera)

		rl.DrawTextureV(
			food_sprite,
			{f32(food_pos.x) * CELL_SIZE, f32(food_pos.y) * CELL_SIZE},
			rl.WHITE,
		)

		for i in 0 ..< snake_length {
			part_sprite := snake_body_sprite
			dir: Vec2i

			if i == 0 {
				part_sprite = snake_head_sprite
				dir = snake[i] - snake[i + 1]
			} else if i == snake_length - 1 {
				part_sprite = snake_tail_sprite
				dir = snake[i - 1] - snake[i]
			} else {
				dir = snake[i - 1] - snake[i]
			}

			rot := math.atan2(f32(dir.y), f32(dir.x)) * math.DEG_PER_RAD

			source := rl.Rectangle{0, 0, f32(part_sprite.width), f32(part_sprite.height)}

			dest := rl.Rectangle {
				f32(snake[i].x) * CELL_SIZE + CELL_SIZE / 2,
				f32(snake[i].y) * CELL_SIZE + CELL_SIZE / 2,
				CELL_SIZE,
				CELL_SIZE,
			}

			rl.DrawTexturePro(part_sprite, source, dest, {CELL_SIZE, CELL_SIZE} / 2, rot, rl.WHITE)

			score := snake_length - 3
			score_str := fmt.ctprintf("Score: %v", score)

			if score > high_score {
				high_score = score
			}
			high_score_str := fmt.ctprintf("High score: %v", high_score)

			rl.DrawText(score_str, 5, CANVAS_SIZE - 14, 10, rl.GRAY)
			rl.DrawText(high_score_str, 55, CANVAS_SIZE - 14, 10, rl.GRAY)
		}
		if game_over {
			rl.DrawText("Game Over!", 4, 4, 25, rl.RED)
			rl.DrawText("Press Enter to play again", 4, 30, 15, rl.BLACK)
		}

		rl.EndMode2D()
		rl.EndDrawing()
		free_all(context.temp_allocator)
	}

	rl.UnloadTexture(snake_head_sprite)
	rl.UnloadTexture(snake_body_sprite)
	rl.UnloadTexture(snake_tail_sprite)
	rl.UnloadTexture(food_sprite)
	rl.UnloadSound(eat_sound)
	rl.UnloadSound(crash_sound)

	rl.CloseAudioDevice()
	rl.CloseWindow()
}
