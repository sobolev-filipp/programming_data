extends Node3D
# =============================================================================
#  «Собери свой компьютер» — учебная 3D-игра (Godot 4).
#  Ребёнок вращает корпус мышью и по очереди устанавливает детали ПК
#  в правильном порядке, читая карточку «что это и зачем».
#
#  Модели грузятся из res://models/<имя>.glb и автоматически подгоняются
#  под нужный размер. Если файла нет — показывается процедурная заглушка,
#  поэтому игра запускается даже с неполным набором моделей.
#
#  РЕЖИМ НАСТРОЙКИ (клавиша F1): позволяет подвинуть/повернуть/масштабировать
#  текущую деталь и видеть её точные координаты — чтобы подогнать слоты под
#  конкретные модели. Значения из панели настройки вставляются в таблицу PARTS.
# =============================================================================

# --- Данные о деталях. order = порядок установки. -----------------------------
# pos/rot/size — стартовые значения; подгоняются в режиме настройки (F1).
# (var, а не const: в Godot 4 const-массивы только для чтения, а мы правим pos.)
var PARTS := [
	# Деталь на плате задаётся "loc" — координатой в ЛОКАЛЬНОЙ системе платы
	# (x — вдоль платы, y — от платы к стеклу, z — вниз по плате). Деталь в корпусе
	# (плата/накопитель/БП) задаётся мировой "pos".
	{
		"id": "motherboard", "order": 1,
		"name": "Материнская плата",
		"desc": "Главная плата компьютера. К ней подключаются все остальные детали — как дороги в городе соединяют все дома.",
		"color": Color(0.15, 0.55, 0.25),
		"size": 2.4, "loc": Vector3(0.0, 0.0, 0.0), "rot": Vector3(0, 0, 0),
	},
	{
		"id": "cpu", "order": 2,
		"name": "Процессор (CPU)",
		"desc": "«Мозг» компьютера. Он считает и принимает все решения — миллиарды действий в секунду!",
		"color": Color(0.7, 0.7, 0.75),
		"size": 0.5, "loc": Vector3(0.5, 0.07, 0.0), "rot": Vector3(0, 0, 0),
	},
	{
		"id": "cooler", "order": 3,
		"name": "Кулер (охлаждение)",
		"desc": "Охлаждает процессор, чтобы тот не перегрелся. Как вентилятор, который спасает в жару.",
		"color": Color(0.55, 0.6, 0.7),
		"size": 0.95, "loc": Vector3(0.5, 0.4, 0.0), "rot": Vector3(0, 0, 0),
	},
	{
		"id": "ram", "order": 4,
		"name": "Оперативная память (ОЗУ)",
		"desc": "Быстрая память для того, чем компьютер занят прямо сейчас. Выключил питание — она всё забывает.",
		"color": Color(0.2, 0.35, 0.7),
		"size": 1.0, "loc": Vector3(0.95, 0.16, 0.0), "rot": Vector3(0, 90, 0),
	},
	{
		"id": "gpu", "order": 5,
		"name": "Видеокарта (GPU)",
		"desc": "Рисует картинку на экране: игры, видео и 3D. Чем она мощнее, тем красивее графика.",
		"color": Color(0.15, 0.15, 0.18),
		"size": 2.0, "loc": Vector3(0.0, 0.22, 0.6), "rot": Vector3(0, 90, 0),
	},
	{
		"id": "ssd", "order": 6,
		"name": "Накопитель (SSD)",
		"desc": "Постоянная память. Здесь живут файлы, фото и программы — они остаются даже после выключения.",
		"color": Color(0.25, 0.25, 0.3),
		"size": 0.8, "pos": Vector3(-0.35, -1.5, 0.45), "rot": Vector3(0, 0, 0),
	},
	{
		"id": "psu", "order": 7,
		"name": "Блок питания",
		"desc": "Даёт энергию всем деталям. Превращает ток из розетки в тот, что нужен компьютеру.",
		"color": Color(0.3, 0.3, 0.32),
		"size": 1.5, "pos": Vector3(0.15, -1.5, -0.1), "rot": Vector3(0, 0, 0),
	},
	# --- Провода: соединяем блок питания с деталями (kind = "wire") ---
	{
		"id": "wire_mb", "order": 8, "kind": "wire",
		"name": "Провод питания платы",
		"desc": "Толстый кабель от блока питания даёт материнской плате электричество. Без него ничего не включится!",
		"color": Color(0.95, 0.8, 0.2),
		"from_id": "psu", "from_off": Vector3(-0.1, 0.5, 0.1),
		"to_id": "motherboard", "to_off": Vector3(0.15, 0.55, -0.75),
	},
	{
		"id": "wire_gpu", "order": 9, "kind": "wire",
		"name": "Провод питания видеокарты",
		"desc": "Мощной видеокарте нужно много энергии — её питает отдельный кабель от блока питания.",
		"color": Color(0.9, 0.4, 0.15),
		"from_id": "psu", "from_off": Vector3(0.1, 0.5, 0.2),
		"to_id": "gpu", "to_off": Vector3(0.25, 0.15, 0.2),
	},
	{
		"id": "wire_ssd", "order": 10, "kind": "wire",
		"name": "Провод питания накопителя",
		"desc": "Тонкий кабель питает накопитель, где хранятся все файлы и программы.",
		"color": Color(0.2, 0.7, 0.9),
		"from_id": "psu", "from_off": Vector3(-0.2, 0.45, 0.2),
		"to_id": "ssd", "to_off": Vector3(0.1, 0.12, 0.1),
	},
]

# Плата — якорь. Матрица переводит ЛОКАЛЬНЫЕ координаты платы (x — длина, y — от платы
# к стеклу, z — вниз по плате) в мир: длина → глубина корпуса (−Z), «наружу» → +X (к стеклу),
# «вниз по плате» → −Y. Так плата стоит поперёк узкой оси корпуса и не торчит.
const BOARD_POS := Vector3(-0.45, 0.35, 0.1)
func _board_basis() -> Basis:
	return Basis(Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, -1, 0))

# Корпус — стоит с самого начала, в него всё ставим.
const CASE := {
	"id": "case", "name": "Корпус",
	"size": 4.6, "pos": Vector3(0, 0, 0), "rot": Vector3(0, 0, 0),
	"color": Color(0.2, 0.22, 0.26),
}

const MODELS_DIR := "res://models/"
const STAGING_POS := Vector3(0.0, 3.1, 1.6)   # где «парит» деталь текущего шага

# --- Состояние ---------------------------------------------------------------
var cam: Camera3D
var cam_target := Vector3(0, 0.1, 0)
var cam_yaw := deg_to_rad(-35.0)
var cam_pitch := deg_to_rad(18.0)
var cam_dist := 9.5

var mouse_down := false
var drag_dist := 0.0
var last_mouse := Vector2.ZERO

var step := 0                       # индекс текущей детали в PARTS
var installed := 0
var pending_area: Area3D            # зона, куда сейчас можно кликнуть
var ghost_root: Node3D             # подсвеченная «призрак»-зона
var ghost_mat: StandardMaterial3D
var staging_part: Node3D            # деталь, парящая рядом (ждёт установки)
var staging_base_basis: Basis       # её базовая ориентация (крутится вокруг неё)
var staging_angle := 0.0
var installed_root: Node3D          # сюда складываем установленные детали
var time := 0.0
var finished := false

# --- Настройка (F1) ----------------------------------------------------------
var tune := false
var tune_label: Label

# --- UI ----------------------------------------------------------------------
var ui: CanvasLayer
var progress_label: Label
var card_name: Label
var card_desc: Label
var steps_box: VBoxContainer
var step_labels := []
var hint_label: Label
var hint_timer := 0.0
var win_overlay: Control
var win_badge: Button
var boot_label: Label


func _ready() -> void:
	_setup_world()
	_setup_camera()
	_build_case()
	_build_ui()
	_start_step()
	_show_hint("Крути мышью — поворот корпуса. Колесо — приблизить.", 4.0)


# =============================================================================
#  МИР, СВЕТ, КАМЕРА
# =============================================================================
func _setup_world() -> void:
	installed_root = Node3D.new()
	installed_root.name = "Installed"
	add_child(installed_root)

	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0.09, 0.11, 0.16)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.55, 0.6, 0.7)
	e.ambient_light_energy = 0.9
	env.environment = e
	add_child(env)

	var key := DirectionalLight3D.new()
	key.rotation = Vector3(deg_to_rad(-50), deg_to_rad(-40), 0)
	key.light_energy = 1.2
	add_child(key)

	var fill := DirectionalLight3D.new()
	fill.rotation = Vector3(deg_to_rad(-20), deg_to_rad(130), 0)
	fill.light_energy = 0.4
	add_child(fill)

	# «Пол» — лёгкая площадка, чтобы корпус не висел в пустоте.
	var ground := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = Vector2(30, 30)
	ground.mesh = pm
	var fm := StandardMaterial3D.new()
	fm.albedo_color = Color(0.13, 0.15, 0.2)
	ground.material_override = fm
	ground.position = Vector3(0, -2.6, 0)
	add_child(ground)


func _setup_camera() -> void:
	cam = Camera3D.new()
	cam.fov = 55
	add_child(cam)
	_update_camera()


func _update_camera() -> void:
	cam_pitch = clamp(cam_pitch, deg_to_rad(-80), deg_to_rad(85))
	cam_dist = clamp(cam_dist, 4.0, 20.0)
	var basis := Basis.from_euler(Vector3(cam_pitch, cam_yaw, 0))
	cam.position = cam_target + basis * Vector3(0, 0, cam_dist)
	cam.look_at(cam_target, Vector3.UP)


# =============================================================================
#  ЗАГРУЗКА / ПОСТРОЕНИЕ ДЕТАЛЕЙ
# =============================================================================
# Возвращает Node3D, отцентрованный в (0,0,0) и подогнанный под target размера.
func _make_visual(id: String, target: float, color: Color) -> Node3D:
	var wrap := Node3D.new()
	var path := MODELS_DIR + id + ".glb"
	if ResourceLoader.exists(path):
		var packed := load(path)
		if packed:
			var inst: Node3D = packed.instantiate()
			wrap.add_child(inst)
			_normalize(inst, target)
			return wrap
	# --- Заглушка (если модели нет) ---
	var box := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = Vector3(target, target * 0.65, target * 0.25)
	box.mesh = bm
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	box.material_override = m
	wrap.add_child(box)
	var tag := Label3D.new()
	tag.text = "? нет модели"
	tag.pixel_size = 0.004
	tag.position = Vector3(0, target * 0.5, 0)
	tag.modulate = Color(1, 0.8, 0.3)
	wrap.add_child(tag)
	return wrap


# Масштабирует и центрирует inst так, чтобы наибольшая сторона = target.
var _have_aabb := false
var _acc_aabb := AABB()

func _normalize(inst: Node3D, target: float) -> void:
	_have_aabb = false
	_acc_aabb = AABB()
	_collect_aabb(inst, Transform3D.IDENTITY)
	if not _have_aabb:
		return
	var sz := _acc_aabb.size
	var maxd: float = max(sz.x, max(sz.y, sz.z))
	if maxd <= 0.0001:
		return
	var s := target / maxd
	inst.scale = Vector3(s, s, s)
	inst.position = -_acc_aabb.get_center() * s


func _collect_aabb(node: Node3D, xform: Transform3D) -> void:
	if node is VisualInstance3D:
		var a: AABB = (node as VisualInstance3D).get_aabb()
		var wa: AABB = xform * a
		if _have_aabb:
			_acc_aabb = _acc_aabb.merge(wa)
		else:
			_acc_aabb = wa
			_have_aabb = true
	for c in node.get_children():
		if c is Node3D:
			_collect_aabb(c, xform * (c as Node3D).transform)


func _basis_from_deg(v: Vector3) -> Basis:
	return Basis.from_euler(Vector3(deg_to_rad(v.x), deg_to_rad(v.y), deg_to_rad(v.z)))


# Мировая позиция детали: на плате — из локальных координат, иначе — как задано.
func _part_world_pos(p: Dictionary) -> Vector3:
	if p.has("loc"):
		return BOARD_POS + _board_basis() * (p.loc as Vector3)
	return p.pos


# Мировая ориентация детали: на плате — поворот платы ∘ локальный поворот детали.
func _part_world_basis(p: Dictionary) -> Basis:
	if p.has("loc"):
		return _board_basis() * _basis_from_deg(p.rot)
	return _basis_from_deg(p.rot)


func _find_part(id: String) -> Dictionary:
	for pp in PARTS:
		if pp.id == id:
			return pp
	return {}


func _wire_from(p: Dictionary) -> Vector3:
	return _part_world_pos(_find_part(p.from_id)) + (p.from_off as Vector3)


func _wire_to(p: Dictionary) -> Vector3:
	return _part_world_pos(_find_part(p.to_id)) + (p.to_off as Vector3)


# Строит кабель-трубку между точками a и b с провисанием вниз.
func _make_wire(a: Vector3, b: Vector3, color: Color) -> MeshInstance3D:
	var sag: float = min(0.5, a.distance_to(b) * 0.28)
	var mid := (a + b) * 0.5 + Vector3(0, -sag, 0)
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var segs := 18
	var ring := 6
	var radius := 0.045
	var prev: Array = []
	for i in segs + 1:
		var t := float(i) / segs
		var p: Vector3 = a.lerp(mid, t).lerp(mid.lerp(b, t), t)
		var t2: float = clamp(t + 0.01, 0.0, 1.0)
		var p2: Vector3 = a.lerp(mid, t2).lerp(mid.lerp(b, t2), t2)
		var dir := (p2 - p).normalized()
		var up := Vector3.UP if absf(dir.dot(Vector3.UP)) < 0.9 else Vector3.RIGHT
		var side := dir.cross(up).normalized()
		var upn := side.cross(dir).normalized()
		var cur: Array = []
		for j in ring:
			var ang := TAU * j / ring
			cur.append(p + (side * cos(ang) + upn * sin(ang)) * radius)
		if i > 0:
			for j in ring:
				var j2 := (j + 1) % ring
				st.add_vertex(prev[j]); st.add_vertex(prev[j2]); st.add_vertex(cur[j])
				st.add_vertex(prev[j2]); st.add_vertex(cur[j2]); st.add_vertex(cur[j])
		prev = cur
	st.generate_normals()
	var mi := MeshInstance3D.new()
	mi.mesh = st.commit()
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 0.5
	mi.material_override = m
	return mi


func _build_case() -> void:
	var vis := _make_visual(CASE.id, CASE.size, CASE.color)
	vis.position = CASE.pos
	vis.rotation_degrees = CASE.rot
	vis.name = "Case"
	installed_root.add_child(vis)


# =============================================================================
#  ШАГИ СБОРКИ
# =============================================================================
func _start_step() -> void:
	_clear_pending()
	if step >= PARTS.size():
		_win()
		return
	var p: Dictionary = PARTS[step]
	if p.get("kind", "part") == "wire":
		_start_wire_step(p)
		return
	var wpos: Vector3 = _part_world_pos(p)

	# 1) Призрак-зона в корпусе (куда ставить).
	ghost_root = Node3D.new()
	var gbox := MeshInstance3D.new()
	var bm := BoxMesh.new()
	var s: float = p.size
	bm.size = Vector3(s, s * 0.7, s * 0.5)
	gbox.mesh = bm
	ghost_mat = StandardMaterial3D.new()
	ghost_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ghost_mat.albedo_color = Color(0.3, 0.9, 1.0, 0.28)
	ghost_mat.emission_enabled = true
	ghost_mat.emission = Color(0.35, 0.9, 1.0)
	ghost_mat.emission_energy_multiplier = 1.0
	gbox.material_override = ghost_mat
	ghost_root.add_child(gbox)
	var glab := Label3D.new()
	glab.text = "◄ сюда"
	glab.pixel_size = 0.004
	glab.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	glab.position = Vector3(0, s * 0.6 + 0.2, 0)
	glab.modulate = Color(0.6, 0.95, 1.0)
	glab.outline_size = 6
	glab.no_depth_test = true
	ghost_root.add_child(glab)
	ghost_root.transform = Transform3D(_part_world_basis(p), wpos)
	installed_root.add_child(ghost_root)

	# 2) Кликабельная зона (Area3D).
	pending_area = Area3D.new()
	var col := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(s, s * 0.7, s * 0.5) * 1.3
	col.shape = shape
	pending_area.add_child(col)
	pending_area.position = wpos
	installed_root.add_child(pending_area)

	# 3) Парящая деталь (ждёт установки).
	staging_part = _make_visual(p.id, p.size, p.color)
	staging_base_basis = _part_world_basis(p)
	staging_angle = 0.0
	staging_part.transform = Transform3D(staging_base_basis, STAGING_POS)
	add_child(staging_part)

	_update_card(p)
	_update_steps()


func _start_wire_step(p: Dictionary) -> void:
	var b := _wire_to(p)
	# призрак — светящийся разъём в точке подключения
	ghost_root = Node3D.new()
	var gs := MeshInstance3D.new()
	var sm := SphereMesh.new()
	sm.radius = 0.16
	sm.height = 0.32
	gs.mesh = sm
	ghost_mat = StandardMaterial3D.new()
	ghost_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ghost_mat.albedo_color = Color(p.color.r, p.color.g, p.color.b, 0.4)
	ghost_mat.emission_enabled = true
	ghost_mat.emission = p.color
	gs.material_override = ghost_mat
	ghost_root.add_child(gs)
	var glab := Label3D.new()
	glab.text = "◄ подключи"
	glab.pixel_size = 0.004
	glab.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	glab.position = Vector3(0, 0.32, 0)
	glab.modulate = p.color
	glab.outline_size = 6
	glab.no_depth_test = true
	ghost_root.add_child(glab)
	ghost_root.position = b
	installed_root.add_child(ghost_root)
	# зона клика
	pending_area = Area3D.new()
	var col := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 0.35
	col.shape = shape
	pending_area.add_child(col)
	pending_area.position = b
	installed_root.add_child(pending_area)
	staging_part = null
	_update_card(p)
	_update_steps()


func _place_current() -> void:
	if finished or step >= PARTS.size():
		return
	var p: Dictionary = PARTS[step]

	# Гасим подсветку/зону.
	if is_instance_valid(ghost_root):
		ghost_root.queue_free()
	if is_instance_valid(pending_area):
		pending_area.queue_free()
	pending_area = null

	# Провод: рисуем кабель между блоком питания и деталью.
	if p.get("kind", "part") == "wire":
		var w := _make_wire(_wire_from(p), _wire_to(p), p.color)
		var mat: StandardMaterial3D = w.material_override
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		var c: Color = mat.albedo_color
		c.a = 0.0
		mat.albedo_color = c
		installed_root.add_child(w)
		create_tween().tween_property(mat, "albedo_color:a", 1.0, 0.35)
		installed += 1
		step += 1
		_flash_progress()
		_show_hint("Подключено: " + p.name, 2.0)
		await get_tree().create_timer(0.4).timeout
		_start_step()
		return

	# Деталь летит из «парения» в слот.
	var part := staging_part
	staging_part = null
	part.reparent(installed_root)
	part.transform = Transform3D(_part_world_basis(p), part.position)
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(part, "position", _part_world_pos(p), 0.45)
	tw.parallel().tween_property(part, "scale", part.scale, 0.45).from(part.scale * 1.25)

	installed += 1
	step += 1
	_flash_progress()
	_show_hint("Отлично! " + p.name + " на месте.", 2.0)
	await get_tree().create_timer(0.5).timeout
	_start_step()


func _clear_pending() -> void:
	if is_instance_valid(ghost_root):
		ghost_root.queue_free()
	if is_instance_valid(pending_area):
		pending_area.queue_free()
	if is_instance_valid(staging_part):
		staging_part.queue_free()
	ghost_root = null
	pending_area = null
	staging_part = null


# =============================================================================
#  ВВОД (камера + установка + режим настройки)
# =============================================================================
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			cam_dist -= 0.7
			_update_camera()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			cam_dist += 0.7
			_update_camera()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				mouse_down = true
				drag_dist = 0.0
				last_mouse = event.position
			else:
				mouse_down = false
				if drag_dist < 6.0:
					_try_click(event.position)
	elif event is InputEventMouseMotion and mouse_down:
		var rel: Vector2 = event.relative
		drag_dist += rel.length()
		cam_yaw -= rel.x * 0.01
		cam_pitch -= rel.y * 0.01
		_update_camera()
	elif event is InputEventKey and event.pressed:
		_handle_key(event.keycode)


func _try_click(mouse_pos: Vector2) -> void:
	if pending_area == null:
		return
	var from := cam.project_ray_origin(mouse_pos)
	var to := from + cam.project_ray_normal(mouse_pos) * 100.0
	var q := PhysicsRayQueryParameters3D.create(from, to)
	q.collide_with_areas = true
	q.collide_with_bodies = false
	var hit := get_world_3d().direct_space_state.intersect_ray(q)
	if hit and hit.has("collider"):
		if hit.collider == pending_area:
			_place_current()
		else:
			_show_hint("Не сюда — свети́тся нужное место. Приглядись!", 1.6)


func _handle_key(code: int) -> void:
	if code == KEY_F1:
		tune = not tune
		tune_label.visible = tune
		_update_tune_label()
		_show_hint("Режим настройки: " + ("ВКЛ" if tune else "выкл"), 1.5)
		return
	if code == KEY_R:
		get_tree().reload_current_scene()
		return
	if not tune or step >= PARTS.size():
		return
	# --- Настройка позиции текущей детали (правим "loc" для деталей на плате, иначе "pos") ---
	var p: Dictionary = PARTS[step]
	if p.get("kind", "part") == "wire":
		return
	var key: String = "loc" if p.has("loc") else "pos"
	var pos: Vector3 = p[key]
	var d := 0.05
	match code:
		KEY_LEFT: pos.x -= d
		KEY_RIGHT: pos.x += d
		KEY_UP: pos.z -= d
		KEY_DOWN: pos.z += d
		KEY_PAGEUP: pos.y += d
		KEY_PAGEDOWN: pos.y -= d
		KEY_BRACKETLEFT:
			p.size = maxf(0.1, float(p.size) - 0.05)
		KEY_BRACKETRIGHT:
			p.size = float(p.size) + 0.05
		KEY_COMMA:
			var r: Vector3 = p.rot; r.y -= 15.0; p.rot = r
		KEY_PERIOD:
			var r2: Vector3 = p.rot; r2.y += 15.0; p.rot = r2
	p[key] = pos
	PARTS[step] = p
	# Перестроить текущий шаг с новыми значениями.
	_start_step()
	_update_tune_label()


# =============================================================================
#  ПРОЦЕСС (анимации)
# =============================================================================
func _process(delta: float) -> void:
	time += delta
	if ghost_mat:
		ghost_mat.emission_energy_multiplier = 1.2 + 0.8 * sin(time * 4.0)
	if is_instance_valid(staging_part):
		staging_angle += delta * 0.8
		var bob := STAGING_POS + Vector3(0, sin(time * 2.0) * 0.12, 0)
		staging_part.transform = Transform3D(Basis(Vector3.UP, staging_angle) * staging_base_basis, bob)
	if hint_timer > 0.0:
		hint_timer -= delta
		if hint_timer <= 0.0:
			hint_label.visible = false


# =============================================================================
#  ИНТЕРФЕЙС
# =============================================================================
func _build_ui() -> void:
	ui = CanvasLayer.new()
	add_child(ui)

	# Верхняя панель.
	var title := Label.new()
	title.text = "🖥  Собери свой компьютер"
	title.add_theme_font_size_override("font_size", 26)
	title.position = Vector2(24, 16)
	ui.add_child(title)

	progress_label = Label.new()
	progress_label.add_theme_font_size_override("font_size", 22)
	progress_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	progress_label.position = Vector2(-260, 20)
	progress_label.size = Vector2(240, 30)
	progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	ui.add_child(progress_label)

	# Панель шагов (справа).
	var steps_panel := PanelContainer.new()
	steps_panel.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
	steps_panel.position = Vector2(-280, -170)
	steps_panel.custom_minimum_size = Vector2(260, 0)
	ui.add_child(steps_panel)
	steps_box = VBoxContainer.new()
	steps_box.add_theme_constant_override("separation", 6)
	steps_panel.add_child(steps_box)
	var sh := Label.new()
	sh.text = "Порядок сборки:"
	sh.add_theme_font_size_override("font_size", 18)
	steps_box.add_child(sh)
	for p in PARTS:
		var l := Label.new()
		l.add_theme_font_size_override("font_size", 16)
		steps_box.add_child(l)
		step_labels.append(l)

	# Карточка детали (слева снизу).
	var card := PanelContainer.new()
	card.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	card.position = Vector2(24, -190)
	card.custom_minimum_size = Vector2(420, 0)
	ui.add_child(card)
	var cbox := VBoxContainer.new()
	cbox.add_theme_constant_override("separation", 8)
	card.add_child(cbox)
	card_name = Label.new()
	card_name.add_theme_font_size_override("font_size", 22)
	card_name.modulate = Color(0.6, 0.95, 1.0)
	cbox.add_child(card_name)
	card_desc = Label.new()
	card_desc.add_theme_font_size_override("font_size", 17)
	card_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_desc.custom_minimum_size = Vector2(400, 0)
	cbox.add_child(card_desc)

	# Подсказка (по центру сверху).
	hint_label = Label.new()
	hint_label.add_theme_font_size_override("font_size", 20)
	hint_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	hint_label.position = Vector2(-300, 70)
	hint_label.size = Vector2(600, 30)
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.modulate = Color(1, 0.95, 0.5)
	hint_label.visible = false
	ui.add_child(hint_label)

	# Кнопки (снизу справа).
	var reset_btn := Button.new()
	reset_btn.text = "↺ Заново"
	reset_btn.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	reset_btn.position = Vector2(-140, -50)
	reset_btn.size = Vector2(120, 34)
	reset_btn.pressed.connect(func(): get_tree().reload_current_scene())
	ui.add_child(reset_btn)

	# Метка режима настройки.
	tune_label = Label.new()
	tune_label.add_theme_font_size_override("font_size", 15)
	tune_label.position = Vector2(24, 60)
	tune_label.modulate = Color(0.6, 1, 0.6)
	tune_label.visible = false
	ui.add_child(tune_label)

	# Экран победы.
	_build_win_overlay()
	_update_progress()


func _build_win_overlay() -> void:
	win_overlay = Control.new()
	win_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	win_overlay.visible = false
	ui.add_child(win_overlay)
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.6)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	win_overlay.add_child(dim)
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_CENTER)
	box.position = Vector2(-200, -120)
	box.custom_minimum_size = Vector2(400, 0)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 16)
	win_overlay.add_child(box)
	var w := Label.new()
	w.text = "🎉 Компьютер собран!"
	w.add_theme_font_size_override("font_size", 34)
	w.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(w)
	boot_label = Label.new()
	boot_label.add_theme_font_size_override("font_size", 20)
	boot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boot_label.text = "Нажми кнопку питания, чтобы включить ПК."
	box.add_child(boot_label)
	var power := Button.new()
	power.text = "⏻  Включить"
	power.add_theme_font_size_override("font_size", 22)
	power.custom_minimum_size = Vector2(200, 50)
	power.pressed.connect(_power_on)
	box.add_child(power)
	var again := Button.new()
	again.text = "↺ Собрать заново"
	again.custom_minimum_size = Vector2(200, 40)
	again.pressed.connect(func(): get_tree().reload_current_scene())
	box.add_child(again)
	var close := Button.new()
	close.text = "← Посмотреть сборку"
	close.custom_minimum_size = Vector2(200, 36)
	close.pressed.connect(func(): win_overlay.visible = false)
	box.add_child(close)

	# Медаль в углу: появляется в конце, по клику открывает результат.
	win_badge = Button.new()
	win_badge.text = "🏆 Молодец!\nпосмотреть результат"
	win_badge.add_theme_font_size_override("font_size", 20)
	win_badge.set_anchors_preset(Control.PRESET_TOP_LEFT)
	win_badge.position = Vector2(24, 110)
	win_badge.custom_minimum_size = Vector2(240, 64)
	win_badge.modulate = Color(1, 0.9, 0.4)
	win_badge.visible = false
	win_badge.pressed.connect(func(): win_overlay.visible = true)
	ui.add_child(win_badge)


func _power_on() -> void:
	boot_label.text = "Загрузка..."
	await get_tree().create_timer(1.2).timeout
	boot_label.text = "✅ Готово! Компьютер работает."


func _update_card(p: Dictionary) -> void:
	card_name.text = str(p.order) + ". " + p.name
	card_desc.text = p.desc


func _update_steps() -> void:
	for i in PARTS.size():
		var l: Label = step_labels[i]
		var nm: String = PARTS[i].name
		if i < step:
			l.text = "✔ " + nm
			l.modulate = Color(0.5, 0.9, 0.5)
		elif i == step:
			l.text = "▶ " + nm
			l.modulate = Color(0.6, 0.95, 1.0)
		else:
			l.text = "•  " + nm
			l.modulate = Color(0.6, 0.6, 0.65)


func _update_progress() -> void:
	progress_label.text = "Собрано: %d / %d" % [installed, PARTS.size()]


func _flash_progress() -> void:
	_update_progress()
	var tw := create_tween()
	progress_label.scale = Vector2(1.3, 1.3)
	tw.tween_property(progress_label, "scale", Vector2.ONE, 0.3)


func _show_hint(text: String, secs: float) -> void:
	hint_label.text = text
	hint_label.visible = true
	hint_timer = secs


func _update_tune_label() -> void:
	if step >= PARTS.size():
		tune_label.text = ""
		return
	var p: Dictionary = PARTS[step]
	if p.get("kind", "part") == "wire":
		tune_label.text = "НАСТРОЙКА: провод «%s» (позиции берутся от деталей)" % p.name
		return
	var key: String = "loc" if p.has("loc") else "pos"
	var v: Vector3 = p[key]
	tune_label.text = "НАСТРОЙКА [%s]\nстрелки=X/Z  PgUp/PgDn=Y  [ ]=размер  , .=поворот\n%s=Vector3(%.2f, %.2f, %.2f)  size=%.2f  rot=Vector3(%.0f, %.0f, %.0f)" % [
		p.name, key, v.x, v.y, v.z, p.size, p.rot.x, p.rot.y, p.rot.z
	]


func _win() -> void:
	finished = true
	win_badge.visible = true
	win_overlay.visible = true    # первый раз показываем результат сразу
	_update_steps()
	_show_hint("Компьютер собран! Нажми 🏆 в углу, чтобы посмотреть результат.", 4.0)
