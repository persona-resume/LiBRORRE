class StoryCommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @story = Story.find(params[:story_id])
    @story_comment = @story.story_comments.new(story_comment_params)
    @story_comment.user_id = current_user.id
    @story_comments = @story.story_comments.reverse
    respond_to do |format|
      if @story_comment.save
        @story_comment = StoryComment.new
        @story_comments = @story.story_comments.reverse
        format.js { flash.now[:success] = "トークルームへ投稿しました。" }
      else
        flash.now[:alert] = "投稿に失敗しました。"
        format.js { render 'error' }
      end
    end
  end

  def destroy
    @story_comment = StoryComment.find(params[:id])
    @story = Story.find(@story_comment.story_id)
    respond_to do |format|
      if @story_comment.destroy
        @story_comments = @story.story_comments.reverse
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
    @story_comment = StoryComment.find(params[:id])
    respond_to do |format|
      if @story_comment.destroy
        @story_comments = StoryComment.all.reverse
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

  def story_comment_params
    params.require(:story_comment).permit(:story_id, :user_id, :comment)
  end

end
