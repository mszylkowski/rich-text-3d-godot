<h1 align="center">
<img src="addons/rich_text_3d/rich_text_3d.svg" width="60"><br>
RichText3D for Godot
</h1>

**A performant 3D [BBCode](https://docs.godotengine.org/en/4.4/tutorials/ui/bbcode_in_richtextlabel.html) renderer for [Godot](https://godotengine.org/).**

![world](https://raw.githubusercontent.com/mszylkowski/rich-text-3d-godot/main/screenshots/animation.gif)

### Features

- Can be added from the **Create Node** and similar menus.
- Renders **BBCode in real time** into a 3D plane.
- Supports **all standard BBCode** rendering features, such as `[color]`, `[b]`, `[i]`, `[img]`, `[table]`, `[font]`, `[font_size]`, etc. All features of BBCode are listed in the [Godot Docs](https://docs.godotengine.org/en/4.4/tutorials/ui/bbcode_in_richtextlabel.html#reference).
- Exposes **adjustable resolution** (pixels per Godot world unit), element size, and virtual text width; with automatic text wrapping.
- **Horizontal and vertical alignments** fully match the 2D version of RichTextLabel.
- **Optimizes rendering** to happen only when properties change, and at most once per frame.
- Supports **animated text** (by disabling the optimization and rendering the SubViewport every frame, use with care).
- Does not pollute the scene tree or the `.tscn` files with any extra children.
- The `StandardMaterial` in `material_override` can be updated in the editor without loss.

### Solutions

- Does not support by default custom [Text effects](https://docs.godotengine.org/en/4.4/tutorials/ui/bbcode_in_richtextlabel.html#text-effects) (custom or default) since it renders the text once per property change.
  - To use custom effects, extend the class `RichText3D` and on the `_init` function, add effects to the property `_text_2d.custom_effects`.
    ```gdscript
    @tool class_name MyCoolText extends RichText3D

    func _init() -> void:
      _text_2d.custom_effects = = [...]
    ```
  - Or, set the field from any other script.
- Does not support custom `ShaderMaterial`s.
  - Since this is not trivial, the best would be to fork the file and change the way the texture is being set so it populates the appropriate parameter in the custom shader using `set_shader_parameter` will work.

## Showcase

![create_node](https://raw.githubusercontent.com/mszylkowski/rich-text-3d-godot/main/screenshots/create_node.png)

![inspector](https://raw.githubusercontent.com/mszylkowski/rich-text-3d-godot/main/screenshots/inspector.png)

![resolutions](https://raw.githubusercontent.com/mszylkowski/rich-text-3d-godot/main/screenshots/resolutions.png)

