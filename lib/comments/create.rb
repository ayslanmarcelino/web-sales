module Comments
  class Create
    def initialize(resource:, author:, description:, enterprise:)
      self.resource = resource
      self.author = author
      self.description = description
      self.enterprise = enterprise
    end

    def call
      create!
    end

    private

    def create!
      resource.comments.create(author:, description:, enterprise:)
    end

    attr_accessor :resource, :author, :description, :enterprise
  end
end
