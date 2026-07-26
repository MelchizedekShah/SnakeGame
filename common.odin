package snake

import rl "vendor:raylib"

WINDOWS_SIZE :: 900
GRID_WIDTH :: 20
CELL_SIZE :: 16
CANVAS_SIZE :: GRID_WIDTH * CELL_SIZE
GAME_BACKROUND: rl.Color = {45, 52, 70, 255}
TICK_RATE :: 0.13
Vec2i :: [2]int
MAX_SNAKE_LENGTH :: GRID_WIDTH * GRID_WIDTH
gm: GameModes

Snake :: struct {
	body:      [MAX_SNAKE_LENGTH]Vec2i,
	length:    int,
	direction: Direction,
	score:     Score,
	game_over: bool,
	food:      Vec2i,
}

Score :: struct {
	current: int,
	high:    int,
}

Direction :: struct {
	move:         Vec2i,
	change_thick: bool,
	tick_timer:   f32,
}

Assets :: struct {
	using sound:   Sound,
	using texture: Texture,
}

Sound :: struct {
	crash: rl.Sound,
	eat:   rl.Sound,
}

Texture :: struct {
	food_sprite: rl.Texture,
	head_sprite: rl.Texture,
	tail_sprite: rl.Texture,
	body_sprite: rl.Texture,
}


GameModes :: enum {
	Menu,
	SinglePlayer,
	DoublePlayer,
}
