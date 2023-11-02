@tool
extends EditorPlugin

var annotations = []

func _enter_tree():
	# Initialization of the plugin goes here.
	get_viewport().connect("gui_focus_changed", Callable(self, "_on_gui_focus_changed"))

func _on_gui_focus_changed(node: Node):
	if node is TextEdit:
		for child in node.get_children():
			if child is ColorRect or child is RichTextLabel:
				child.queue_free()

		var colorRect = ColorRect.new()
		colorRect.color = Color.REBECCA_PURPLE
		var annotation = Annotation.new()

		annotation.set_node(colorRect)
		var line = 20
		annotation.set_line(line)
		print(len(node.get_line(line)))
		annotation.set_column(len(node.get_line(line)))
		node.add_child(colorRect)
		annotation.update()
		annotations.append(annotation)

		var textLabel = RichTextLabel.new()
		textLabel.text = "Mariuus"
		textLabel.fit_content = true
		textLabel.text_direction = 0
		textLabel.autowrap_mode = TextServer.AUTOWRAP_OFF

		var textAnnotation = Annotation.new()
		textAnnotation.set_node(textLabel)
		textAnnotation.set_line(33)
		node.add_child(textLabel)
		textAnnotation.set_to_line_end()

		textAnnotation.update()
		annotations.append(textAnnotation)

func _process(delta):
	for annotation in annotations:
		var anno = (annotation as Annotation)
		if is_instance_valid(anno.node) and anno.node is RichTextLabel:
			(anno.node as RichTextLabel).text = str(delta)
		anno.update()

class Annotation:
	var line = 0
	var column = 0
	var node: Control
	var lastScrollPos

	func update():
		if not is_instance_valid(node): return
		var parent = node.get_parent() as TextEdit
		if parent.scroll_vertical == lastScrollPos:
			return
		else:
			lastScrollPos = parent.scroll_vertical
		var rect = parent.get_rect_at_line_column(line, column)
		if rect.position.y >= 0:
			node.show()
			node.set_position(Vector2(rect.end.x, rect.position.y))
		else:
			node.hide()
#		node.set_size(rect.size)

	func set_line(line: int):
		self.line = line

	func set_column(column: int):
		self.column = column

	func set_node(node: Control):
		self.node = node

	func set_to_line_end():
		var parent = node.get_parent() as TextEdit
		self.set_column(len(parent.get_line(line)))
