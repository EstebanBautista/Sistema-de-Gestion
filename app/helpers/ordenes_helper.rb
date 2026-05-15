module OrdenesHelper
  # Autor: Esteban Muñoz
  # Qué hace: Retorna el HTML de un badge de Bootstrap según el estado de la orden
  # Recibe: orden - instancia del modelo Orden
  # Retorna: string HTML con el badge correspondiente
  def badge_estado(orden)
    clases = {
      "pendiente"   => "bg-warning text-dark",
      "en_progreso" => "bg-primary",
      "completada"  => "bg-success"
    }
    content_tag :span, orden.estado.humanize, class: "badge #{clases[orden.estado]}"
  end
end
