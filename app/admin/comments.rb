ActiveAdmin.register(Comment, as: 'platform_comment') do
  menu priority: 3

  permit_params :description

  actions :index, :show, :edit, :update, :destroy

  includes :resource, :author

  index do
    selectable_column
    id_column
    column :resource
    column :author
    column(:description) { |resource| text_with_bullet(resource.description) }
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :resource
      row :author
      row(:description) { text_with_bullet(resource.description) }
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input(:description)
    end

    f.actions
  end
end
