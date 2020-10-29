require "cpf_cnpj"
class Account < ApplicationRecord
  belongs_to :user
  has_many :operations, dependent: :destroy

  validates_uniqueness_of :cpf
  validates_presence_of :cpf
  validate :validate_cpf, if: -> { cpf.present? }
  validate :existance, on: :create, if: -> { user.present? }

  def validate_cpf
    if CPF.valid?(cpf).nil?
      errors.add(:base, 'Invalid cpf')
    end
  end

  def existance
    if Account.find_by(user_id: user.id).present?
      errors.add(:base, 'The user already has an account')
    end
  end
end
