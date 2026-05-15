class OrdenesController < ApplicationController
  before_action :buscar_orden, only: [:show, :edit, :update, :destroy, :archivar, :cambiar_estado, :descargar_pdf]

  # Autor: Esteban Muñoz
  # Qué hace: Lista todas las órdenes activas con filtro opcional por estado y paginación
  # Recibe: params[:estado] opcional para filtrar, params[:page] para paginación
  # Retorna: colección de órdenes paginada con cliente incluido
  def index
    @ordenes = Orden.kept.includes(:cliente).order(created_at: :desc)
    @ordenes = @ordenes.where(estado: Orden.estados[params[:estado]]) if params[:estado].present?
    @ordenes = @ordenes.page(params[:page]).per(15)
  end

  # Autor: Esteban Muñoz
  # Qué hace: Muestra el detalle de una orden
  # Recibe: params[:id]
  # Retorna: instancia @orden
  def show
  end

  # Autor: Esteban Muñoz
  # Qué hace: Inicializa una nueva orden vacía para el formulario
  # Recibe: nada
  # Retorna: instancia @orden vacía
  def new
    @orden = Orden.new
  end

  # Autor: Esteban Muñoz
  # Qué hace: Crea una nueva orden asociada a un cliente
  # Recibe: params[:orden] con titulo, descripcion, cliente_id
  # Retorna: redirige al detalle si éxito, o renderiza formulario con errores
  def create
    @orden = Orden.new(orden_params)
    if @orden.save
      redirect_to @orden, notice: "Orden creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Autor: Esteban Muñoz
  # Qué hace: Muestra el formulario de edición de la orden
  # Recibe: params[:id]
  # Retorna: instancia @orden para edición
  def edit
  end

  # Autor: Esteban Muñoz
  # Qué hace: Actualiza los datos de una orden existente
  # Recibe: params[:id] y params[:orden]
  # Retorna: redirige al detalle si éxito, o renderiza formulario con errores
  def update
    if @orden.update(orden_params)
      redirect_to @orden, notice: "Orden actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Autor: Esteban Muñoz
  # Qué hace: Bloquea la eliminación física de órdenes (restricción crítica)
  # Recibe: params[:id]
  # Retorna: redirección con mensaje de error
  def destroy
    redirect_to ordenes_path, alert: "Use 'Archivar' para eliminar una orden. Los registros no se borran físicamente."
  end

  # Autor: Esteban Muñoz
  # Qué hace: Realiza un soft delete de la orden marcando deleted_at
  # Recibe: params[:id]
  # Retorna: redirige al listado con confirmación
  def archivar
    @orden.discard
    redirect_to ordenes_path, notice: "Orden archivada correctamente."
  end

  # Autor: Esteban Muñoz
  # Qué hace: Cambia el estado de una orden (pendiente, en_progreso, completada)
  # Recibe: params[:id] y params[:estado] con el nuevo estado
  # Retorna: redirige a la misma página con confirmación
  def cambiar_estado
    nuevo_estado = params[:estado]
    if Orden.estados.key?(nuevo_estado)
      @orden.update(estado: nuevo_estado)
      redirect_to @orden, notice: "Estado cambiado a '#{nuevo_estado.humanize}'."
    else
      redirect_to @orden, alert: "Estado inválido."
    end
  end

  # Autor: Esteban Muñoz
  # Qué hace: Genera y descarga un PDF con los datos de la orden y su cliente
  # Recibe: params[:id]
  # Retorna: respuesta HTTP con el PDF como descarga
  def descargar_pdf
    pdf = OrdenPdf.new(@orden)
    send_data pdf.render,
              filename: "#{@orden.folio}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  private

  # Autor: Esteban Muñoz
  # Qué hace: Busca la orden por id usando el scope kept
  # Recibe: params[:id]
  # Retorna: asigna @orden o lanza RecordNotFound
  def buscar_orden
    @orden = Orden.kept.includes(:cliente).find(params[:id])
  end

  # Autor: Esteban Muñoz
  # Qué hace: Define los parámetros permitidos para Orden
  # Recibe: params[:orden]
  # Retorna: ActionController::Parameters filtrado
  def orden_params
    params.require(:orden).permit(:titulo, :descripcion, :cliente_id)
  end
end
