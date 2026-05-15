class Orden < ApplicationRecord
  include Discard::Model
  self.discard_column = :deleted_at
  self.table_name = "ordenes"

  # Autor: Esteban Muñoz
  # Qué hace: Excluye registros soft-deleted de todas las consultas por defecto
  # Recibe: nada
  # Retorna: scope con registros no eliminados
  default_scope { kept }

  belongs_to :cliente

  enum :estado, { pendiente: 0, en_progreso: 1, completada: 2 }

  validates :titulo,      presence: true
  validates :descripcion, presence: true
  validates :cliente_id,  presence: true
  validates :folio,       uniqueness: true, allow_nil: true

  before_create :generar_folio

  private

  # Autor: Esteban Muñoz
  # Qué hace: Genera un folio único correlativo en formato ORD-00001 antes de crear el registro
  # Recibe: nada (se ejecuta como callback)
  # Retorna: asigna self.folio
  def generar_folio
    ultimo_folio = Orden.with_discarded.order(created_at: :desc).pluck(:folio).first
    siguiente_numero = if ultimo_folio.present?
      ultimo_folio.gsub("ORD-", "").to_i + 1
    else
      1
    end
    self.folio = "ORD-#{siguiente_numero.to_s.rjust(5, '0')}"
  end
end
