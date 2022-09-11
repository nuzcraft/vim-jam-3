tool
extends TileSet

const GRASS = 0
const MUD = 1
const SNOW = 2
const ASH = 3

var binds = {
	GRASS: [MUD, SNOW, ASH],
	MUD: [GRASS, SNOW, ASH],
	SNOW: [GRASS, MUD, ASH],
	ASH: [GRASS, MUD, SNOW],
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
