@tool
class_name EditorToast
extends RefCounted
## ONE job: show a short message to the user.
## In the editor it pops up as a toast (bottom-right). It is also printed to Output.

enum Level { INFO, WARNING, ERROR } # same order as Godot's EditorToaster severity

static func push(message: String, level: Level = Level.INFO) -> void:
	print("[City] ", message)
	if Engine.is_editor_hint():
		var toaster: Object = EditorInterface.get_editor_toaster()
		toaster.push_toast(message, level)

# A number box reached its smallest or biggest allowed value.
static func limit_reached(setting: String, is_max: bool, limit_value: float) -> void:
	var word := "maximum" if is_max else "minimum"
	push("%s: %s is %s." % [setting, word, String.num(limit_value)], Level.WARNING)
