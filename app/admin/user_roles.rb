ActiveAdmin.register(User::Role) do
  menu priority: 7

  includes :enterprise, :created_by, :user

  permit_params User::Role.permitted_params

  filter :enterprise
  filter :user
  filter :kind_cd, as: :select, collection: User::Role::ROLES
  filter :created_at

  form do |f|
    f.inputs('Informações gerais') do
      f.input(:enterprise)
      f.input(:user, as: :select, collection: User.all.map { |user| ["#{user.person.name} | #{user.email}", user.id] })
      f.input(:kind_cd, as: :select, collection: User::Role::ROLES)
    end

    f.actions
  end

  controller do
    def create
      params[:user_role][:created_by_id] = current_user.id

      super
    end
  end
end
