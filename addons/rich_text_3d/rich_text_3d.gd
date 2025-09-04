## Renders a [url=https://docs.godotengine.org/en/4.4/tutorials/ui/bbcode_in_richtextlabel.html]BBCode[/url] Rich Text in 3D.
@tool
@icon("rich_text_3d.svg")
class_name RichText3D
extends MeshInstance3D

#region Exported Params
## The label's text in [url=https://docs.godotengine.org/en/latest/tutorials/ui/bbcode_in_richtextlabel.html]BBCode[/url] format.
@export_multiline var text := "":
	set(t): text = t; _queue_render()

@export_group("Formatting")
## Controls the text's horizontal alignment. Supports left, center, right, and fill.
@export_enum("Left", "Center", "Right", "Fill") var horizontal_alignment := 1:
	set(a): horizontal_alignment = a; _queue_render()
## Controls the text's vertical alignment. Supports top, center, bottom, and fill.
@export_enum("Top", "Center", "Bottom", "Fill") var vertical_alignment := 1:
	set(a): vertical_alignment = a; _queue_render()

@export_group("Render options")
## 3D size of the text plane in the world.
@export var size := Vector2(.7, .5):
	set(s):
		size = Vector2(maxf(0, s.x), maxf(0, s.y))
		(mesh as PlaneMesh).size = size
		_queue_render()
## Resolution in pixels per unit.
@export_range(100, 2000, 10, "exp", "suffix:px/unit") var resolution := 1000.:
	set(r): resolution = r; _queue_render()
## Width of the text in the 2D world.
@export_range(100, 2000, 5, "exp", "suffix:px") var text_width := 350.:
	set(s): text_width = s; _queue_render()
## Renders the text every frame.[br][br]
## [b]WARNING[/b]: This is very inefficient and will lose most performance benefits.
@export var render_continuously := false:
	set(c):
		render_continuously = c
		if render_continuously:
			_subviewport.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
		else:
			_subviewport.render_target_update_mode = SubViewport.UPDATE_ONCE
			_queue_render()
#endregion

@onready var _standard_mat: StandardMaterial3D

var _subviewport: SubViewport
var _text_2d : RichTextLabel

func _init() -> void:
	_text_2d = RichTextLabel.new()
	_subviewport = SubViewport.new()
	if material_override and material_override is StandardMaterial3D:
		material_override.albedo_texture = null
		_standard_mat = material_override.duplicate()
		_standard_mat.resource_local_to_scene = true
		material_override = _standard_mat
	else:
		_standard_mat = StandardMaterial3D.new()
		_standard_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		material_override = _standard_mat
	mesh = PlaneMesh.new()
	mesh.size = size

func _ready() -> void:
	add_child(_subviewport)
	_subviewport.add_child(_text_2d)
	if not render_continuously:
		_subviewport.render_target_update_mode = SubViewport.UPDATE_DISABLED

	_text_2d.bbcode_enabled = true
	_text_2d.scroll_active = false
	_text_2d.fit_content = true
	_subviewport.disable_3d = true
	_subviewport.transparent_bg = true
	_subviewport.size_2d_override_stretch = true
	await _queue_render()
	material_override.albedo_texture = _subviewport.get_texture()


func _queue_render() -> void:
	_subviewport.size = size * resolution
	_subviewport.size_2d_override = Vector2(text_width, text_width * size.y / size.x)
	_text_2d.size = _subviewport.size_2d_override
	_text_2d.text = text
	_text_2d.horizontal_alignment = horizontal_alignment as HorizontalAlignment
	_text_2d.vertical_alignment = vertical_alignment as VerticalAlignment

	if _subviewport.render_target_update_mode == SubViewport.UPDATE_DISABLED:
		_subviewport.render_target_update_mode = SubViewport.UPDATE_ONCE
		await RenderingServer.frame_post_draw
		_subviewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
	else:
		await RenderingServer.frame_post_draw

func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_PRE_SAVE:
		_standard_mat.albedo_texture = null
	elif what == NOTIFICATION_EDITOR_POST_SAVE:
		_standard_mat.albedo_texture = _subviewport.get_texture()
