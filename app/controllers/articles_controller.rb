class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update]
  def new
    @article = Article.new
  end

  def index
    @articles = Article.order(:created_at).reverse_order.page(params[:page]).per(10).search(params[:search])
    @stories = Story.order(:created_at).reverse_order.page(params[:page]).per(10).search(params[:search])
    return unless request.xhr?
    case params[:type]
    when 'article'
      render "/articles/article_list"
    when 'story'
      render "/stories/story_list"
    end
  end

  def show
    @article = Article.find(params[:id])
    @stories = @article.stories.order(:created_at).reverse_order.page(params[:page]).per(10)
    @article_comments = @article.article_comments.reverse
    @article_comment = ArticleComment.new
    @admin_comment_page = false
  end

  def edit
    @article = Article.find(params[:id])
    @category_list = @article.categories.pluck(:name).join(",")
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    category_list = params[:category_list].split(",")
    if @article.save
      @article.save_article_categories(category_list)
      redirect_to article_path(@article), notice: 'エラー記事を作成しました。'
    else
      flash.now[:alert] = 'エラー記事の作成に失敗しました'
      render :new
    end
  end

  def update
    @article = Article.find(params[:id])
    @article.user_id = current_user.id
    @old_article = @article
    if @article.update(article_params)
      create_article_history(@old_article)
      category_list = params[:category_list].split(",")
      @article.save_article_categories(category_list)
      redirect_to article_path(@article), notice: 'エラー記事を更新しました。'
    else
      flash.now[:alert] = 'エラー記事の更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.destroy
      redirect_to articles_path, notice: 'ストーリーを削除しました'
    else
      @category_list = params[:category_list].split(",")
      flash.now[:alert] = 'ストーリーの更新に失敗しました。'
      render :edit
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :mean, :cause)
  end
end
