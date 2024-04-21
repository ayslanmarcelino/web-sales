# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    load_and_authorize_resource
    before_action :enterprise, only: [:show, :disable]
    before_action :user, only: [:edit, :update]
    before_action :verify_password, only: [:update]

    def index
      @query, @users = Common::Index.call(
        klass: User,
        params: params[:q],
        includes: :person,
        joins: :roles,
        order: [created_at: :desc],
        accessible_by: current_ability
      )
    end

    def show; end

    def new
      @user = User.new
      @user.build_person
      @user.person.build_address
    end

    def create
      @user = User.new(create_params)
      @user.person.kind = :person
      @user.person.owner = @user
      @user.person.enterprise_id = current_user.current_enterprise.id

      if @user.save
        UserMailer.with(user: @user).new_user.deliver_now
        custom_redirect(path: admin_users_path, type: :success)
      else
        render(:new, status: :unprocessable_entity)
      end
    end

    def edit; end

    def update
      if @user.update(user_params.except(:email))
        custom_redirect(path: admin_users_path, type: :success)
      else
        render(:edit, status: :unprocessable_entity)
      end
    end

    def disable
      if @user.active?
        disable!(@user)
        custom_redirect(path: admin_users_path, type: :success)
      else
        custom_redirect(path: admin_users_path, type: :danger)
      end
    end

    def activate
      if disabled?(@user)
        activate!(@user)
        custom_redirect(path: admin_users_path, type: :success)
      else
        custom_redirect(path: admin_users_path, type: :danger)
      end
    end

    def update_current_enterprise
      if current_user.roles.map(&:enterprise_id).include?(params[:change_enterprise][:id].to_i)
        current_user.update(current_enterprise_id: params[:change_enterprise][:id])
        flash[:success] = "Agora você está acessando a empresa #{current_user.current_enterprise.trade_name}."
      else
        flash[:alert] = 'Você não possui permissão'
      end

      redirect_to(dashboard_index_path)
    end

    private

    def user_params
      params.require(:user)
            .permit(
              User.permitted_params,
              person_attributes: [
                Person.permitted_params,
                { address_attributes: Address.permitted_params },
                { contacts_attributes: Contact.permitted_params }
              ]
            )
    end

    def create_params
      user_params.except(:password, :password_confirmation).merge(
        password: user_params[:email],
        password_confirmation: user_params[:email],
        created_by: current_user
      )
    end

    def enterprise
      @enterprise ||= Enterprise.where(id: current_user.roles.map(&:enterprise_id))
    end

    def user
      @user ||= User.find(params[:id])
    end

    def verify_password
      unless params[:user][:password].presence || params[:user][:password_confirmation].presence
        params[:user].extract!(:password, :password_confirmation)
      end
    end
  end
end
