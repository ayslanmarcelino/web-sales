module Users
  module Roles
    class Create < ApplicationService
      def initialize(params:, enterprise:)
        @params = params
        @enterprise = enterprise
      end

      def call
        create!
      end

      private

      def create!
        person
        user
        create_user_role!
      end

      def person
        @person ||= People::Create.call(params: @params, enterprise: @enterprise, kind: :person)
      end

      def user
        @user ||= Users::Create.call(params: @params, person: @person, enterprise: @enterprise)
      end

      def create_user_role!
        @role ||= User::Role.create(
          kind_cd: :owner,
          enterprise_id: @enterprise.id,
          user_id: @user.id,
          created_by: @enterprise.created_by
        )

        @role.save
      end
    end
  end
end
