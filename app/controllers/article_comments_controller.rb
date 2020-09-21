class ArticleCommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @article = Article.find(params[:article_id])
    @article_comment = @article.article_comments.new(article_comment_params)
    @article_comment.user_id = current_user.id
    @article_comments = @article.article_comments.reverse
    respond_to do |format|
      if @article_comment.save
        @article_comments = @article.article_comments.reverse
        @article_comment = ArticleComment.new
        format.js { flash.now[:success] = "トークルームへ投稿しました。" }
      else
        flash.now[:alert] = "投稿に失敗しました。"
        format.js { render 'error' }
      end
    end
  end

  def destroy
    @article_comment = ArticleComment.find(params[:id])
    @article = Article.find(@article_comment.article_id)
    respond_to do |format|
      if @article_comment.destroy
        @article_comments = @article.article_comments.reverse
        format.html
        format.js { flash.now[:success] = "投稿を削除しました。" }
      else
        flash.now[:alert] = "投稿の削除に失敗しました。"
        format.html
        format.js { render 'error'}
      end
    end
  end

  def destroy_from_admin_page
    @article_comment = ArticleComment.find(params[:id])
    respond_to do |format|
      if @article_comment.destroy
        @article_comments = ArticleComments.all.reverse
        format.html
        format.js { flash.now[:success] = "投稿を削除しました。" }
      else
        flash.now[:alert] = "投稿の削除に失敗しました。"
        format.html
        format.js { render 'error'}
      end
    end
  end

  private

  def article_comment_params
    params.require(:article_comment).permit(:article_id, :user_id, :comment)
  end
end
