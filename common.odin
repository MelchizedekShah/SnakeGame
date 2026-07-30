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

Assets :: struct {
	food1_sprite: rl.Texture,
	head1_sprite: rl.Texture,
	tail1_sprite: rl.Texture,
	body1_sprite: rl.Texture,
	head2_sprite: rl.Texture,
	body2_sprite: rl.Texture,
	tail2_sprite: rl.Texture,
	food2_sprite: rl.Texture,
	// Sound
	grow:         rl.Sound,
	shrink:       rl.Sound,
	crash:        rl.Sound,
	eat:          rl.Sound,
}

GameModes :: enum {
	Menu,
	SinglePlayer,
	DoublePlayer,
}

KeyStructure :: struct {
	up:    bool,
	down:  bool,
	right: bool,
	left:  bool,
}

Layout :: enum {
	Arrows,
	Letters,
}

MoveResult :: struct {
	snake:    Snake,
	wrapped:  bool,
	tail_pos: Vec2i,
	moved:    bool,
}
