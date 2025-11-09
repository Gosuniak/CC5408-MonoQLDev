extends RigidBody2D

# Esta caja puede tener gravedad normal o invertida
# Se configura al momento de crearla

func _ready():
	print("Caja física creada con gravity_scale: ", gravity_scale)

# Función para configurar la gravedad
func configurar_gravedad(invertir: bool):
	if invertir:
		gravity_scale = -1.0  # Flota hacia arriba
		print("Caja configurada con gravedad INVERTIDA")
	else:
		gravity_scale = 1.0   # Cae normalmente
		print("Caja configurada con gravedad NORMAL")
