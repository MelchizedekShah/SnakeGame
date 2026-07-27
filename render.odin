package snake

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

write_text :: proc(
	title: cstring,
	title_size: i32,
	message1: cstring,
	message2: cstring,
	message_size: i32,
) {
	rl.ClearBackground(GAME_BACKROUND)

	title_width := rl.MeasureText(title, title_size)
	message1_width := rl.MeasureText(message1, message_size)
	option2_width := rl.MeasureText(message2, message_size)

	rl.DrawText(title, (WINDOWS_SIZE - title_width) / 2, 180, title_size, rl.RED)
	rl.DrawText(message1, (WINDOWS_SIZE - message1_width) / 2, 530, message_size, rl.LIGHTGRAY)
	rl.DrawText(message2, (WINDOWS_SIZE - option2_width) / 2, 600, message_size, rl.LIGHTGRAY)
}

draw_snake :: proc(
	snake: Snake,
	head: rl.Texture,
	body: rl.Texture,
	tail: rl.Texture,
	objective: rl.Texture,
) {
	rl.DrawTextureV(
		objective,
		{f32(snake.food.x) * CELL_SIZE, f32(snake.food.y) * CELL_SIZE},
		rl.WHITE,
	)

	for i in 0 ..< snake.length {
		part_sprite := body
		dir: Vec2i

		if i == 0 {
			part_sprite = head
			dir = snake.body[i] - snake.body[i + 1]
		} else if i == snake.length - 1 {
			part_sprite = tail
			dir = snake.body[i - 1] - snake.body[i]
		} else {
			dir = snake.body[i - 1] - snake.body[i]
		}

		rot := math.atan2(f32(dir.y), f32(dir.x)) * math.DEG_PER_RAD

		source := rl.Rectangle{0, 0, f32(part_sprite.width), f32(part_sprite.height)}

		dest := rl.Rectangle {
			f32(snake.body[i].x) * CELL_SIZE + CELL_SIZE / 2,
			f32(snake.body[i].y) * CELL_SIZE + CELL_SIZE / 2,
			CELL_SIZE,
			CELL_SIZE,
		}

		rl.DrawTexturePro(part_sprite, source, dest, {CELL_SIZE, CELL_SIZE} / 2, rot, rl.WHITE)
	}
}

draw_score :: proc(snake: ^Snake, location_base_x: i32, color: rl.Color) {
	snake.score.current = snake.length - 3
	score_str := fmt.ctprintf("Score: %v", snake.score.current)

	if snake.score.current > snake.score.high {
		snake.score.high = snake.score.current
	}
	high_score_str := fmt.ctprintf("High score: %v", snake.score.high)

	rl.DrawText(score_str, 5 + location_base_x, CANVAS_SIZE - 14, 10, color)
	rl.DrawText(high_score_str, 55 + location_base_x, CANVAS_SIZE - 14, 10, color)

}
