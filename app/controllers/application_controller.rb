# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :active_enterprise?
  before_action :active_user?

  helper_method :disabled?
  helper_method :white_label

  rescue_from CanCan::AccessDenied, with: :access_denied

  ACTIONS = [:success, :danger].freeze

  def active_enterprise?
    if current_user.present? && disabled?(current_user.person.enterprise)
      sign_out(current_user)
      redirect_to(new_user_session_path,
                  alert: 'Sua empresa está desativada. Para mais informações, entre em contato com o administrador do sistema.')
    end
  end

  def active_user?
    if current_user.present? && disabled?(current_user)
      sign_out(current_user)
      redirect_to(
        new_user_session_path,
        alert: 'Seu usuário está desativado. Para mais informações, entre em contato com o seu gestor.'
      )
    end
  end

  def access_denied(exception)
    redirect_to(dashboard_index_path)
    flash[:danger] = exception.message
  end

  def disable!(resource)
    resource.update!(active: false)
  end

  def activate!(resource)
    resource.update!(active: true)
  end

  def disabled?(resource)
    !resource.active?
  end

  def white_label_kind
    current_user&.current_enterprise&.white_label&.kind
  end

  def white_label
    return :default if current_user.blank? || WhiteLabel::KINDS.exclude?(white_label_kind)

    white_label_kind
  end

  def custom_redirect(path:, type:)
    redirect_to(path)
    flash[type] = custom_redirect_message(type)
  end

  private

  def custom_redirect_message(type)
    return unless ACTIONS.include?(type)

    send("#{type}_message")
  end

  def danger_message
    "#{translated_controller} não pôde ser #{translated_action}."
  end

  def success_message
    "#{translated_controller} #{translated_action} com sucesso."
  end

  def translated_action
    I18n.t("application.#{"#{action_name}_action"}", default: nil)&.downcase
  end

  def translated_controller
    I18n.t("activerecord.models.#{controller_path.singularize}", default: nil)
  end
end
