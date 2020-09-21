class LibrariesController < ApplicationController
  before_action :authenticate_user!

  def index
    @libraries = current_user.libraries.order(:created_at).reverse_order.page(params[:page]).per(10)
    @stories = current_user.stories.order(:created_at).reverse_order.page(params[:page]).per(10)
    return unless request.xhr?
    case params[:type]
    when 'stock'
      render "/libraries/stock_list"
    when 'story'
      render "/stories/story_list"
    end
  end

  def create
    @story = Story.find(params[:story_id])
    library = current_user.libraries.new(story_id: @story.id)
    library.save
  end

  def destroy
    @story = Story.find(params[:story_id])
    library = current_user.libraries.find_by(story_id: @story.id)
    library.destroy
  end
end
