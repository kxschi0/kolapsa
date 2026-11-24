@tool
class_name SceneExporter
extends RefCounted
## ONE job: save the generated city as a standalone Godot scene (UC-06).
## The saved scene is a plain Node3D with the tiles as children. It has no
## script, so it works without this plug-in.

static func export_scene(container: Node3D, path: String) -> Error:
	if not path.ends_with(".tscn"):
		path += ".tscn"

	var root := Node3D.new()
	root.name = "City"
	root.scale = container.scale # keeps the chosen tile size

	var count := _export_children(container, root, root)

	if count == 0:
		root.free()
		return ERR_UNCONFIGURED

	var scene := PackedScene.new()
	var err := scene.pack(root)
	if err == OK:
		DirAccess.make_dir_recursive_absolute(path.get_base_dir())
		err = ResourceSaver.save(scene, path)
	root.free()
	return err

# Copies every tile under `source` into `target`. A plain node that is not a tile (Floors, Roads, Block_01...)
# becomes a group of the same name, and is only kept if something ended up inside it.
static func _export_children(source: Node, target: Node3D, root: Node3D) -> int:
	var count := 0
	for child in source.get_children():
		if child.is_queued_for_deletion():
			continue
		if not child.is_in_group(SceneSpawner.GROUP) and child.scene_file_path == "":
			var group := Node3D.new() # same name as in the editor
			group.name = child.name
			target.add_child(group)
			group.owner = root
			var inside := _export_children(child, group, root)
			if inside == 0:
				target.remove_child(group)
				group.free()
			count += inside
			continue
		var copy := _copy_tile(child)
		if copy == null:
			continue # temporary things like the entropy labels
		target.add_child(copy)
		TileBody.set_owner_all(copy, root)
		copy.transform = (child as Node3D).transform
		count += 1
	return count

# A fresh copy of one tile, or null if the node is not a tile.
static func _copy_tile(child: Node) -> Node3D:
	if not child.is_in_group(SceneSpawner.GROUP):
		return null
	var packed: PackedScene = null
	var kind := TileBody.NONE
	var with_collision := false
	var model_xf: Variant = null
	if child.scene_file_path != "":
		packed = load(child.scene_file_path) as PackedScene
	elif child is PhysicsBody3D:
		# A tile wrapped in a body: find the model inside it.
		for inner in child.get_children():
			if inner.scene_file_path != "":
				packed = load(inner.scene_file_path) as PackedScene
				model_xf = (inner as Node3D).transform # keeps the fit to the block
		kind = TileBody.RIGID if child is RigidBody3D else TileBody.STATIC
		with_collision = child.get_node_or_null(TileBody.COLLISION_NAME) != null
	var merged_piece := packed == null and child is PhysicsBody3D and child.get_node_or_null(GroundMerger.MESH_NAME) != null
	if packed == null and not merged_piece:
		return null
	if merged_piece:
		var piece := child.duplicate() as Node3D # a merged ground piece: mesh and collision come along
		piece.remove_from_group(SceneSpawner.GROUP)
		piece.name = child.name
		return piece
	var copy := TileBody.make(packed, kind, with_collision, model_xf)
	copy.name = child.name
	return copy
