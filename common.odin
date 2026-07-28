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
MIN_SNAKE_LENGTH :: 3
DEFAULT_MANIPULATOR_POS :: 15
DEFAULT_MANIPULATOR_NEG :: -15
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

Single_Assets :: struct {
	food1_sprite: rl.Texture,
	head1_sprite: rl.Texture,
	tail1_sprite: rl.Texture,
	body1_sprite: rl.Texture,
	// Sound
	crash:        rl.Sound,
	eat:          rl.Sound,
}

Double_Assets :: struct {
	using single: Single_Assets,
	head2_sprite: rl.Texture,
	body2_sprite: rl.Texture,
	tail2_sprite: rl.Texture,
	food2_sprite: rl.Texture,
	// Sound
	grow:         rl.Sound,
	shrink:       rl.Sound,
}

GameModes :: enum {
	Menu,
	SinglePlayer,
	DoublePlayer,
}
