@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("RichText3D", "VisualInstance3D", preload("rich_text_3d.gd"), preload("rich_text_3d.svg"))


func _exit_tree():
	remove_custom_type("RichText3D")
