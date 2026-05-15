class OrdenPdf
  # Autor: Esteban Muñoz
  # Qué hace: Inicializa el generador de PDF con una orden específica
  # Recibe: orden - instancia del modelo Orden con su cliente asociado
  # Retorna: una nueva instancia de OrdenPdf
  def initialize(orden)
    @orden = orden
    @cliente = orden.cliente
  end

  # Autor: Esteban Muñoz
  # Qué hace: Renderiza el documento PDF completo con todos los datos de la orden y el cliente
  # Recibe: nada
  # Retorna: string binario con el contenido del PDF
  def render
    pdf = Prawn::Document.new(page_size: "A4", margin: [40, 50, 40, 50])

    pdf.font_size 8 do
      pdf.text "Sistema de Registro y Gestión de Órdenes de Servicio Técnico", align: :center, color: "888888"
    end

    pdf.move_down 10
    pdf.stroke_horizontal_rule
    pdf.move_down 20

    pdf.font_size 24 do
      pdf.text @orden.folio, align: :center, style: :bold
    end

    pdf.move_down 5

    pdf.font_size 10 do
      pdf.text "Orden de Servicio Técnico", align: :center, color: "555555"
    end

    pdf.move_down 30

    pdf.font_size 11 do
      pdf.text "Datos de la Orden", style: :bold, color: "1a1a2e"
    end

    pdf.move_down 10

    orden_data = [
      ["Folio",       @orden.folio],
      ["Título",      @orden.titulo],
      ["Descripción", @orden.descripcion],
      ["Estado",      @orden.estado.humanize],
      ["Creada",      I18n.l(@orden.created_at, format: :long)]
    ]

    pdf.table(orden_data, width: pdf.bounds.width) do
      cells.borders = [:bottom]
      cells.padding = [6, 10, 6, 10]
      cells.border_color = "dddddd"
      columns(0).font_style = :bold
      columns(0).text_color = "555555"
      columns(0).width = 120
    end

    pdf.move_down 30

    pdf.font_size 11 do
      pdf.text "Datos del Cliente", style: :bold, color: "1a1a2e"
    end

    pdf.move_down 10

    cliente_data = [
      ["Nombre",  @cliente.nombre],
      ["Correo",  @cliente.correo],
      ["Teléfono", @cliente.telefono]
    ]

    pdf.table(cliente_data, width: pdf.bounds.width) do
      cells.borders = [:bottom]
      cells.padding = [6, 10, 6, 10]
      cells.border_color = "dddddd"
      columns(0).font_style = :bold
      columns(0).text_color = "555555"
      columns(0).width = 120
    end

    pdf.move_down 40
    pdf.stroke_horizontal_rule
    pdf.move_down 10

    pdf.font_size 8 do
      pdf.text "Documento generado el #{I18n.l(Time.current, format: :long)} por el Sistema de Gestión de Órdenes.", align: :center, color: "999999"
    end

    pdf.render
  end
end
