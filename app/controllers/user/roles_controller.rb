class User::RolesController < ApplicationController
  load_and_authorize_resource

  before_action :role, only: [:edit, :destroy]
  before_action :enterprises, only: [:new, :create, :edit]
  before_action :users, only: [:new, :create, :edit]

  def index
    @query, @user_roles = Common::Index.call(
      klass: User::Role,
      includes: [user: :person],
      params: params[:q],
      order: [created_at: :desc],
      accessible_by: current_ability
    )
  end

  def new
    @role = User::Role.new
  end

  def create
    @role = User::Role.new(role_params)
    @role.enterprise_id = enterprise_id if role.enterprise_id.blank?

    if @role.save
      @role.user.update(current_enterprise_id: @role.enterprise_id)

      custom_redirect(path: user_roles_path, type: :success)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit; end

  def update
    if @role.update(role_params)
      custom_redirect(path: user_roles_path, type: :success)
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    if @role.destroy
      custom_redirect(path: user_roles_path, type: :success)
    else
      render(:index, status: :unprocessable_entity)
    end
  end

  private

  def role
    @role ||= User::Role.find(params[:id])
  end

  def enterprises
    @enterprises ||= Enterprise.where(id: current_user.current_enterprise)
  end

  def users
    @users ||= User.includes(:person).where(person: { enterprise_id: current_user.person.enterprise_id })
  end

  def role_params
    params.require(:user_role)
          .permit(User::Role.permitted_params)
          .merge(created_by: current_user)
  end

  def enterprise_id
    params[:user_role][:enterprise_id].presence || current_user.current_enterprise.id
  end
end
