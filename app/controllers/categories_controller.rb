class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @articles = @category.articles.order(:created_at).reverse_order.page(params[:page]).per(10)
    @stories = @category.stories.order(:created_at).reverse_order.page(params[:page]).per(10)
    return unless request.xhr?
    case params[:type]
    when 'article'
      render "/articles/article_list"
    when 'story'
      render "/stories/story_list"
    end
  end
end
