class Cliente < ApplicationRecord
  include Discard::Model
  self.discard_column = :deleted_at

  # Autor: Esteban Muñoz
  # Qué hace: Excluye registros soft-deleted de todas las consultas por defecto
  # Recibe: nada
  # Retorna: scope con registros no eliminados
  default_scope { kept }

  has_many :ordenes, foreign_key: :cliente_id, dependent: :restrict_with_error

  validates :nombre,   presence: true
  validates :telefono, presence: true
  validates :correo,   presence: true,
                       uniqueness: { case_sensitive: false },
                       format: { with: URI::MailTo::EMAIL_REGEXP, message: "no es válido" }
end
