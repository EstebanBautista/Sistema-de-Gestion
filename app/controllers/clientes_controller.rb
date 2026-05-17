class ClientesController < ApplicationController
  before_action :buscar_cliente, only: [:show, :edit, :update, :archivar, :desarchivar]

  # Autor: Esteban Muñoz
  # Qué hace: Lista todos los clientes activos con filtros y paginación
  # Recibe: params[:page], params[:q], params[:letra], params[:fecha_desde], params[:fecha_hasta]
  # Retorna: colección de clientes paginada y filtrada
  def index
    @clientes = Cliente.kept.order(created_at: :desc)

    if params[:q].present?
      @clientes = @clientes.where("nombre LIKE :q OR correo LIKE :q", q: "%#{params[:q]}%")
    end

    if params[:letra].present?
      @clientes = @clientes.where("nombre LIKE :letra", letra: "#{params[:letra]}%")
    end

    if params[:fecha_desde].present?
      @clientes = @clientes.where("created_at >= ?", params[:fecha_desde].to_date.beginning_of_day)
    end

    if params[:fecha_hasta].present?
      @clientes = @clientes.where("created_at <= ?", params[:fecha_hasta].to_date.end_of_day)
    end

    @clientes = @clientes.page(params[:page]).per(15)
  end

  # Autor: Esteban Muñoz
  # Qué hace: Lista todos los clientes archivados (soft-deleted) con filtro por fecha
  # Recibe: params[:page], params[:fecha_desde], params[:fecha_hasta]
  # Retorna: colección de clientes archivados paginada
  def archivados
    @clientes = Cliente.with_discarded.where.not(deleted_at: nil).order(deleted_at: :desc)

    if params[:fecha_desde].present?
      @clientes = @clientes.where("deleted_at >= ?", params[:fecha_desde].to_date.beginning_of_day)
    end

    if params[:fecha_hasta].present?
      @clientes = @clientes.where("deleted_at <= ?", params[:fecha_hasta].to_date.end_of_day)
    end

    @clientes = @clientes.page(params[:page]).per(15)
  end

  # Autor: Esteban Muñoz
  # Qué hace: Muestra el detalle de un cliente (incluso archivados) y sus órdenes activas
  # Recibe: params[:id] con el id del cliente
  # Retorna: instancia @cliente y colección @ordenes
  def show
    @ordenes = @cliente.ordenes.kept.order(created_at: :desc)
  end

  # Autor: Esteban Muñoz
  # Qué hace: Inicializa un nuevo cliente vacío para el formulario
  # Recibe: nada
  # Retorna: instancia @cliente vacía
  def new
    @cliente = Cliente.new
  end

  # Autor: Esteban Muñoz
  # Qué hace: Crea un nuevo cliente con los parámetros recibidos
  # Recibe: params[:cliente] con nombre, correo, telefono
  # Retorna: redirige al detalle si éxito, o renderiza el formulario con errores
  def create
    @cliente = Cliente.new(cliente_params)
    if @cliente.save
      redirect_to @cliente, notice: "Cliente creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Autor: Esteban Muñoz
  # Qué hace: Muestra el formulario de edición del cliente
  # Recibe: params[:id]
  # Retorna: instancia @cliente para edición
  def edit
  end

  # Autor: Esteban Muñoz
  # Qué hace: Actualiza los datos de un cliente existente
  # Recibe: params[:id] y params[:cliente] con los campos a actualizar
  # Retorna: redirige al detalle si éxito, o renderiza formulario con errores
  def update
    if @cliente.update(cliente_params)
      redirect_to @cliente, notice: "Cliente actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Autor: Esteban Muñoz
  # Qué hace: Bloquea la eliminación física de clientes (restricción crítica)
  # Recibe: params[:id]
  # Retorna: redirección con mensaje de error
  def destroy
    redirect_to clientes_path, alert: "Use 'Archivar' para eliminar un cliente. Los registros no se borran físicamente."
  end

  # Autor: Esteban Muñoz
  # Qué hace: Realiza un soft delete del cliente marcando deleted_at
  # Recibe: params[:id]
  # Retorna: redirige al listado con confirmación
  def archivar
    @cliente.discard
    redirect_to clientes_path, notice: "Cliente archivado correctamente."
  end

  # Autor: Esteban Muñoz
  # Qué hace: Restaura un cliente archivado limpiando deleted_at
  # Recibe: params[:id]
  # Retorna: redirige al listado de archivados con confirmación
  def desarchivar
    @cliente.undiscard
    redirect_to archivados_clientes_path, notice: "Cliente restaurado correctamente."
  end

  private

  # Autor: Esteban Muñoz
  # Qué hace: Busca el cliente por id (incluye archivados para show, solo activos para edición)
  # Recibe: params[:id]
  # Retorna: asigna @cliente o lanza RecordNotFound
  def buscar_cliente
    if action_name == "show" || action_name == "desarchivar"
      @cliente = Cliente.with_discarded.find(params[:id])
    else
      @cliente = Cliente.kept.find(params[:id])
    end
  end

  # Autor: Esteban Muñoz
  # Qué hace: Define los parámetros permitidos para Cliente
  # Recibe: params[:cliente]
  # Retorna: ActionController::Parameters filtrado
  def cliente_params
    params.require(:cliente).permit(:nombre, :correo, :telefono)
  end
end
