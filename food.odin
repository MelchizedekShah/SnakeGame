package snake

import rl "vendor:raylib"

random_food :: proc(snake: ^Snake) {
	occupied: [GRID_WIDTH][GRID_WIDTH]bool

	for i in 0 ..< snake.length {
		occupied[snake.body[i].x][snake.body[i].y] = true
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
		snake.food = free_cells[random_cell_index]
	}
}
