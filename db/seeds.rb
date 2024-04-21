white_label = FactoryBot.create(:white_label)
enterprise = FactoryBot.create(:enterprise, white_label: white_label, created_by: nil)
admin_master = FactoryBot.create(:user, email: 'admin_master@gmail.com', password: 123_456)
person = FactoryBot.create(:person, :person, owner: admin_master, enterprise: enterprise)

admin_master.update(person: person, current_enterprise_id: enterprise.id)
enterprise.update(created_by: admin_master)

FactoryBot.create(:user_role, kind: :admin_master, user: admin_master, created_by: admin_master, enterprise: enterprise)
