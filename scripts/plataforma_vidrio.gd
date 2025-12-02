extends Node2D

# Referencias
@onready var area_detector = $AreaDetector
@export var capa_visual: TileMapLayer 

@onready var break_platform: AudioStreamPlayer2D = $Break

func _ready():
	# Conexión de señal básica
	if not area_detector.body_entered.is_connected(_on_body_entered):
		area_detector.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Verificamos si es la caja de hierro (o su variante)
	if body.is_in_group("Caja_Hierro") or body.is_in_group("caja_hierro"):
		romper_plataforma()

func romper_plataforma():
	print("¡CRASH! Rompiendo vidrios...")
	
	if capa_visual:
		borrar_tiles_bajo_plataforma()
	
	# Se oculta la plataforma
	visible = false
	
	# Desactivamos el área para evitar que el sonido se repita si cae otra caja
	area_detector.set_deferred("monitoring", false)
	
	# Reproducir sonido y esperar
	if break_platform:
		break_platform.play()
		await break_platform.finished
	
	queue_free()

func borrar_tiles_bajo_plataforma():
	# 1. Obtener el tamaño base de la colisión
	var col_shape = area_detector.get_node_or_null("CollisionShape2D")
	if not col_shape or not col_shape.shape is RectangleShape2D:
		return

	# 2. CALCULAR TAMAÑO REAL: Tamaño base * Escala del objeto
	# global_scale nos dice cuánto lo estiraste en el editor (ej: x2, x0.5)
	var tamano_real = col_shape.shape.size * global_scale
	
	# 3. Calcular esquinas en el mundo
	var esquina_sup_izq = global_position - (tamano_real / 2)
	var esquina_inf_der = global_position + (tamano_real / 2)
	
	# 4. Convertir a coordenadas del mapa (Grid)
	var celda_inicio = capa_visual.local_to_map(capa_visual.to_local(esquina_sup_izq))
	var celda_fin = capa_visual.local_to_map(capa_visual.to_local(esquina_inf_der))
	
	# 5. Barrido y borrado seguro
	for x in range(celda_inicio.x, celda_fin.x + 1):
		for y in range(celda_inicio.y, celda_fin.y + 1):
			var coordenadas = Vector2i(x, y)
			
			var datos_tile = capa_visual.get_cell_tile_data(coordenadas)
			if datos_tile:
				# Verificamos tu capa personalizada para no borrar suelo indestructible
				var es_rompible = datos_tile.get_custom_data("es_destruible")
				
				if es_rompible:
					capa_visual.erase_cell(coordenadas)
