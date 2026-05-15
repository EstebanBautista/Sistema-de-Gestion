# Autor: Esteban Muñoz
# Qué hace: Población inicial de la base de datos con clientes y órdenes de ejemplo
# Recibe: nada (se ejecuta con rails db:seed)
# Retorna: registros creados en la base de datos

puts "--- Poblando base de datos ---"

# === CLIENTES ===

clientes_data = [
  { nombre: "María González", correo: "maria.gonzalez@email.com", telefono: "+56 9 1234 5678" },
  { nombre: "Carlos Muñoz",   correo: "carlos.munoz@email.com",  telefono: "+56 9 2345 6789" },
  { nombre: "Ana Soto",       correo: "ana.soto@email.com",      telefono: "+56 9 3456 7890" }
]

clientes = clientes_data.map do |data|
  Cliente.find_or_create_by!(correo: data[:correo]) do |c|
    c.nombre   = data[:nombre]
    c.telefono = data[:telefono]
    puts "  Cliente creado: #{data[:nombre]}"
  end
end

puts "  #{Cliente.count} clientes en total."

# === ÓRDENES ===

ordenes_data = [
  { titulo: "Reparación de pantalla",              descripcion: "El equipo presenta una línea vertical en la pantalla y pixeles muertos en la esquina superior derecha. Se requiere diagnóstico y reemplazo de pantalla.",                  estado: :completada,   cliente: clientes[0] },
  { titulo: "Limpieza y mantenimiento general",     descripcion: "El equipo se sobrecalienta después de 30 minutos de uso. Se solicita limpieza interna de ventiladores, cambio de pasta térmica y revisión del sistema de refrigeración.",                estado: :en_progreso, cliente: clientes[0] },
  { titulo: "Instalación de software contable",     descripcion: "Instalación y configuración del software de contabilidad Defontana, incluyendo migración de datos desde el sistema anterior y capacitación básica al usuario.",                     estado: :pendiente,    cliente: clientes[1] },
  { titulo: "Configuración de red corporativa",     descripcion: "El cliente solicita reestructuración de la red local: configurar 5 estaciones de trabajo, impresora de red y acceso VPN para teletrabajo.",                                         estado: :pendiente,    cliente: clientes[1] },
  { titulo: "Recuperación de datos",                descripcion: "Disco duro externo WD de 2TB no es reconocido por el sistema operativo. Se escucha un clic intermitente. Solicitud de recuperación de datos críticos del departamento de contabilidad.", estado: :en_progreso, cliente: clientes[2] }
]

ordenes_data.each do |data|
  Orden.find_or_create_by!(titulo: data[:titulo], cliente_id: data[:cliente].id) do |o|
    o.descripcion = data[:descripcion]
    o.estado      = data[:estado]
    o.cliente     = data[:cliente]
    puts "  Orden creada: #{data[:titulo]}"
  end
end

puts "  #{Orden.count} órdenes en total."
puts "--- Población completada ---"
