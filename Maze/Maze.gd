extends Spatial

const N = 1 					# binary 0001
const E = 2 					# binary 0010
const S = 4 					# binary 0100
const W = 8 					# binary 1000

var cell_walls = {
	Vector2(0, -1): N, 			# cardinal directions for NESW
	Vector2(1, 0): E,
	Vector2(0, 1): S, 
	Vector2(-1, 0): W
}

onready var MiniMap = get_node("/root/Game/UI/VP/Map_Containere/MiniMap")

var map = []

var tiles = [
	preload("res://Maze/Tile00.tscn")	# all the tiles we created
	,preload("res://Maze/Tile01.tscn")
	,preload("res://Maze/Tile02.tscn")
	,preload("res://Maze/Tile03.tscn")
	,preload("res://Maze/Tile04.tscn")
	,preload("res://Maze/Tile05.tscn")
	,preload("res://Maze/Tile06.tscn")
	,preload("res://Maze/Tile07.tscn")
	,preload("res://Maze/Tile08.tscn")
	,preload("res://Maze/Tile09.tscn")
	,preload("res://Maze/Tile10.tscn")
	,preload("res://Maze/Tile11.tscn")
	,preload("res://Maze/Tile12.tscn")
	,preload("res://Maze/Tile13.tscn")
	,preload("res://Maze/Tile14.tscn")
	,preload("res://Maze/Tile15.tscn")
]

var mini_tiles = [
	preload("res://MiniMap/Tile00.tscn")	# all the tiles we created
	,preload("res://MiniMap/Tile01.tscn")
	,preload("res://MiniMap/Tile02.tscn")
	,preload("res://MiniMap/Tile03.tscn")
	,preload("res://MiniMap/Tile04.tscn")
	,preload("res://MiniMap/Tile05.tscn")
	,preload("res://MiniMap/Tile06.tscn")
	,preload("res://MiniMap/Tile07.tscn")
	,preload("res://MiniMap/Tile08.tscn")
	,preload("res://MiniMap/Tile09.tscn")
	,preload("res://MiniMap/Tile10.tscn")
	,preload("res://MiniMap/Tile11.tscn")
	,preload("res://MiniMap/Tile12.tscn")
	,preload("res://MiniMap/Tile13.tscn")
	,preload("res://MiniMap/Tile14.tscn")
	,preload("res://MiniMap/Tile15.tscn")
]


var tile_size = 2 # tile size in meters
var mini_tile = 64 # tile size in pixels
var width = 20  # width of map (in tiles)
var height = 10  # height of map (in tiles)

onready var Key = preload("res://Key/key.tscn")
onready var Exit = preload("res://Exit/Exit.tscn")

func _ready():
	randomize()
	make_maze()
	var key = Key.instance()
	key.translate(Vector3((width*tile_size)-1.5,1,1.5))
	add_child(key)
	var exit = Exit.instance()
	exit.translate(Vector3((width*tile_size)-1.5,1,(height*tile_size)-1.5))
	add_child(exit)

func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	for x in range(width):
		map.append([])
		map[x].resize(height)
		for y in range(height):
			unvisited.append(Vector2(x, y))
			map[x][y] = N|E|S|W 		# 15
	var current = Vector2(0, 0)
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			var dir = next - current
			var current_walls = map[current.x][current.y] - cell_walls[dir]
			var next_walls = map[next.x][next.y] - cell_walls[-dir]
			map[current.x][current.y] = current_walls
			map[next.x][next.y] = next_walls
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	for x in range(width):
		for z in range(height):
			var tile = tiles[map[x][z]].instance()
			tile.translation = Vector3(x*tile_size,0,z*tile_size)
			tile.name = "Tile_" + str(x) + "_" + str(z)
			add_child(tile)
			var t2 = mini_tiles[map[x][z]].instance()
			t2.position = Vector2(x,z)*mini_tile
			t2.name = "MTile_" + str(x) + "_" + str(z)
			MiniMap.add_child(t2)
