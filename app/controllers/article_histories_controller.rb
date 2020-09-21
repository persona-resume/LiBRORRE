class ArticleHistoriesController < ApplicationController
  before_action :auth_admin

  def index
    @article = Article.find(params[:id])
    @histories = @article.article_histories
  end

  def show
    @history = ArticleHistory.find(params[:id])
    @present_article = @history.article
  end

  def overwrite
    history = ArticleHistory.find(params[:id])
    @article = history.article
    # overwrite実行前に、記事の編集履歴を作成
    create_article_history(@article)
    # article_historyの内容をarticleへ上書き
    @article.title = history.title
    @article.mean = history.mean
    @article.cause = history.cause
    @article.save
    redirect_to article_path(@article)
  end

end
