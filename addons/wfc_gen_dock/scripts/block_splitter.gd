@tool
class_name BlockSplitter
extends RefCounted
## ONE job: split the floor cells into blocks. A block is a group of floor cells that touch side by side
## (the grey area between streets). Knows nothing about WFC or scenes.
## Returns an Array of {"cells": Dictionary of Vector2i -> true, "rect": Rect2i (the box around the cells)}.
## The order is fixed (top-left block first), so the same layout always gives the same blocks.

static func split(floor_cells: Dictionary) -> Array:
	var starts: Array = floor_cells.keys()
	starts.sort_custom(func(a: Vector2i, b: Vector2i) -> bool: return a.y < b.y or (a.y == b.y and a.x < b.x))
	var seen: Dictionary = {}
	var result: Array = []
	for start: Vector2i in starts:
		if seen.has(start):
			continue
		var cells: Dictionary = {}
		var stack: Array = [start]
		seen[start] = true
		while not stack.is_empty():
			var cur: Vector2i = stack.pop_back()
			cells[cur] = true
			for d in GroundPlanner.DIRS:
				var n: Vector2i = cur + GroundPlanner.DIRS[d]
				if floor_cells.has(n) and not seen.has(n):
					seen[n] = true
					stack.append(n)
		result.append({"cells": cells, "rect": _box(cells)})
	return result

static func _box(cells: Dictionary) -> Rect2i:
	var low := Vector2i(1 << 30, 1 << 30)
	var high := Vector2i(-(1 << 30), -(1 << 30))
	for c: Vector2i in cells:
		low = Vector2i(mini(low.x, c.x), mini(low.y, c.y))
		high = Vector2i(maxi(high.x, c.x), maxi(high.y, c.y))
	return Rect2i(low, high - low + Vector2i.ONE)
