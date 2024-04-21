ActiveAdmin.register(WhiteLabel) do
  menu priority: 1

  actions :index, :show, :new, :create, :edit, :update

  permit_params :active, :description, :kind_cd

  scope('Todos', :all)
  scope('Ativos', :active, default: true)
  scope('Desativados', :disabled)

  filter :description
  filter :created_at

  index do
    selectable_column
    id_column
    column :kind_cd
    column :active
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :kind_cd
      row :description
      row :active
    end

    active_admin_comments
  end

  form do |f|
    f.inputs('Informações gerais') do
      f.input(:description)
      f.input(:kind_cd, as: :select, collection: WhiteLabel::KINDS)
    end

    f.actions
  end

  member_action_button :disable,
                       'Desativar',
                       confirm: 'Tem certeza que deseja DESATIVAR este White Label?',
                       only: :show,
                       if: -> { resource.active? } do
    disable!(resource)
    flash[:notice] = 'White Label desativado com sucesso.'
    redirect_to(admin_white_labels_path)
  end

  member_action_button :activate,
                       'Ativar',
                       confirm: 'Tem certeza que deseja ATIVAR este White Label?',
                       only: :show,
                       if: -> { disabled?(resource) } do
    activate!(resource)
    flash[:notice] = 'White Label ativado com sucesso.'
    redirect_to(admin_white_labels_path)
  end
end
