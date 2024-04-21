ActiveAdmin.register(Contact) do
  menu priority: 5

  permit_params Contact.permitted_params

  index do
    selectable_column
    id_column
    column :person
    column :email
    column :cell_number
    column :telephone_number
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :person
      row :email
      row :cell_number
      row :telephone_number
      row :observation
    end

    active_admin_comments
  end

  form do |f|
    f.inputs('Informações gerais') do
      f.input(:person)
      f.input(:email)
      f.input(:cell_number)
      f.input(:telephone_number)
      f.input(:observation)
    end

    f.actions
  end
end
