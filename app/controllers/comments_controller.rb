class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    comment = create_comment.call

    if comment.persisted?
      comment_redirect(type: :success)
    else
      comment_redirect(type: :danger)
    end
  end

  private

  def resource_type
    params[:resource_type]
  end

  def resource_id
    params[:resource_id]
  end

  def resource
    resource_type.constantize.find(resource_id)
  end

  def comment_params
    params.require(:comment)
          .permit(:description)
          .merge(
            resource:,
            author: current_user,
            enterprise: current_user.current_enterprise
          )
  end

  def create_comment
    Comments::Create.new(
      resource: comment_params[:resource],
      author: comment_params[:author],
      description: comment_params[:description],
      enterprise: comment_params[:enterprise]
    )
  end

  def comment_redirect(type:)
    if resource_type == 'User'
      custom_redirect(path: comments_admin_user_path(resource_id), type:)
    end
  end
end
