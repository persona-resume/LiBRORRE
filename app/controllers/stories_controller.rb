class StoriesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  def new
    @article = Article.find(params[:article_id])
    @story = @article.stories.new
    @story_topic = @story.story_topics.build
    @story_body = @story_topic.story_bodies.build
  end

  def show
    @story = Story.find(params[:id])              # 選択したストーリー
    @article = @story.article                     # 選択したストーリーに関連するエラー記事
    @stories = @article.stories.order(:created_at).reverse_order.page(params[:page]).per(10)  # 同一エラーに関するストーリー
    @topics = @story.story_topics                 # 見出し
    @story_comments = @story.story_comments.reverse
    @story_comment = StoryComment.new
    @admin_comment_page = false                   # 管理者ページからの表示？
    logging_visited_stories(@story)               # 閲覧履歴の記録
  end

  def edit
    @story = Story.find(params[:id])
    unless @story.user.id == current_user.id
      unless current_user.admin == true
        redirect_to story_path(@story), alert: '許可されていないリクエストです。'
        return
      end
    end
    @category_list = @story.categories.pluck(:name).join(",")
  end

  def create
    @article = Article.find(params[:article_id])
    @story = @article.stories.new(story_params)
    unless topics_and_bodies_exists?(@story)
      flash.now[:alert] = '見出し、または本文が不足しています。'
      render :new
      return
    end
    @story.user_id = current_user.id
    @category_list = params[:category_list].split(",")
    if @story.save
      @story.save_story_categories(@category_list)
      redirect_to story_path(@story), notice: 'ストーリーを作成しました。'
    else
      flash.now[:alert] = 'ストーリーの作成に失敗しました。'
      render :new
    end
  end

  def update
    @story = Story.find(params[:id])
    @old_story = @story
    # 管理者、もしくは作成者本人以外はアクセス制限
    unless @story.user_id == current_user.id
      unless current_user.admin == true
        redirect_to story_path(@story), alert: '許可されていないリクエストです。'
        return
      end
    end
    # 見出し、本文が一つもない場合、エラー表示
    @category_list = params[:category_list].split(",")
    if @story.update(story_params)
      unless topics_and_bodies_exists?(@story)
        @old_story.save
        redirect_to edit_story_path(@story), alert: '見出し、または本文が不足しています。'
        return
      end
      @story.save_story_categories(@category_list)
      redirect_to story_path(@story), notice: 'ストーリーを更新しました'
    else
      flash.now[:alert] = 'ストーリーの更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    @story = Story.find(params[:id])
    article = @story.article
    if @story.destroy
      redirect_to article_path(article), notice: 'ストーリーを削除しました'
    else
      @category_list = params[:category_list].split(",")
      flash.now[:alert] = 'ストーリーの削除に失敗しました。'
      render :edit
    end
  end

  def topics_and_bodies_exists?(story)
    # 見出しが無い場合にエラーを表示
    if story.story_topics.blank?
      return false
    end
    # 見出しに対して本文が一つもない場合にエラーを表示
    story.story_topics.each do |topic|
      if topic.story_bodies.blank?
        return false
      end
    end
    return true
  end

  private

  def story_params
    params.require(:story).permit(
      :title,
        story_topics_attributes: [
          :id,
          :title,
          :_destroy,
          story_bodies_attributes: [
            :id,
            :content,
            :text_type,
            :_destroy
          ]
        ]
      )
  end
end
