# Sistema de Registro y Gestión de Órdenes de Servicio Técnico

Aplicación web desarrollada con Ruby on Rails para gestionar órdenes de servicio técnico, clientes y generación de reportes PDF.

## Requisitos Previos

- Ruby 3.3.6
- Rails 8.1.3
- MySQL 8.4.8
- Bundler

## Stack Tecnológico

| Componente       | Tecnología                          |
|------------------|-------------------------------------|
| Backend          | Ruby on Rails 8.1.3                 |
| Base de datos    | MySQL 8.4.8                         |
| Template engine  | Slim                                |
| Frontend         | Bootstrap 5 + Bootstrap Icons (CDN) |
| Paginación       | Kaminari                             |
| Soft delete      | Discard                              |
| PDF              | Prawn + Prawn-Table                 |

## Decisiones Técnicas

### Soft Delete: Discard vs Paranoia
Se eligió **Discard** porque no sobreescribe el método `destroy` de ActiveRecord, a diferencia de Paranoia. Esto permite mantener el comportamiento por defecto de Rails y evitar efectos secundarios en gemas de terceros. Discard simplemente agrega un scope `kept` y un método `discard` que actualiza `deleted_at`, sin modificar el ciclo de vida del modelo.

### PDF: Prawn vs WickedPDF
Se eligió **Prawn** porque es una biblioteca pure-Ruby que no requiere wkhtmltopdf ni ninguna dependencia de sistema. WickedPDF necesita un binario externo (wkhtmltopdf) que no siempre está disponible en todos los entornos. Prawn genera PDFs directamente desde Ruby con control total sobre el layout.

## Configuración Inicial

```bash
# 1. Instalar dependencias
bundle install

# 2. Crear la base de datos
rails db:create

# 3. Ejecutar migraciones
rails db:migrate

# 4. Poblar con datos de ejemplo
rails db:seed

# 5. Iniciar el servidor
rails server
```

La aplicación estará disponible en `http://localhost:3000`.

## Estructura del Proyecto

```
app/
├── controllers/
│   ├── application_controller.rb
│   ├── clientes_controller.rb
│   └── ordenes_controller.rb
├── helpers/
│   └── ordenes_helper.rb
├── models/
│   ├── cliente.rb
│   └── orden.rb
├── pdfs/
│   └── orden_pdf.rb
└── views/
    ├── layouts/application.html.slim
    ├── clientes/ (index, show, new, edit, _form)
    └── ordenes/  (index, show, new, edit, _form)
```

## Rutas Principales

| Método | Ruta                          | Acción                  |
|--------|-------------------------------|-------------------------|
| GET    | `/`                           | Listado de órdenes      |
| GET    | `/clientes`                   | Listado de clientes     |
| GET    | `/clientes/:id`               | Detalle del cliente     |
| GET    | `/clientes/new`               | Nuevo cliente           |
| GET    | `/clientes/:id/edit`          | Editar cliente          |
| PATCH  | `/clientes/:id/archivar`      | Soft delete del cliente |
| GET    | `/ordenes`                    | Listado de órdenes      |
| GET    | `/ordenes/:id`                | Detalle de la orden     |
| PATCH  | `/ordenes/:id/cambiar_estado` | Cambiar estado          |
| GET    | `/ordenes/:id/descargar_pdf`  | Descargar PDF           |
| PATCH  | `/ordenes/:id/archivar`       | Soft delete de la orden |

## Generación de PDF

Para descargar el PDF de una orden, acceder a la vista de detalle de la orden y hacer clic en "Descargar PDF". El PDF incluye:

- Folio de la orden (ej: ORD-00001)
- Título y descripción del servicio
- Estado actual
- Datos del cliente (nombre, correo, teléfono)
- Fecha de generación del documento

## Soft Delete

Ningún registro se elimina físicamente de la base de datos. La columna `deleted_at` se marca con la fecha y hora actual, y los scopes por defecto excluyen automáticamente los registros archivados de todas las consultas.

Para ver registros archivados (en consola):

```ruby
Cliente.with_discarded.where.not(deleted_at: nil)
Orden.with_discarded.where.not(deleted_at: nil)
```

## Licencia

MIT
