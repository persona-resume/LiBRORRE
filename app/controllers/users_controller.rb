class UsersController < ApplicationController
  before_action :ensure_authority, only: [:update, :unsubscribe]
  before_action :auth_admin, only: [:index, :admin, :admin_show, :admin_comments]
  before_action :unsubscribed_user?

  def top
    @articles = Article.page(params[:page]).per(10)
    @stories = Story.order(:created_at).reverse_order.page(params[:page]).per(10)
    @visits = Story.find(Visited.group(:story_id).order('count(story_id) desc').limit(5).pluck(:story_id))
    return unless request.xhr?
    case params[:type]
    when 'article'
      render "/articles/article_list"
    when 'story'
      render "/stories/story_list"
    end
  end

  def about
  end

  def show
    @user = User.find(params[:id])
    # 管理者マイページは、管理者以外に表示させない
    if user_signed_in?
      if @user.admin && current_user.admin == false
        redirect_to root_path, alert: '許可されていないリクエストです。'
        return
      end
    else
      if @user.admin
        redirect_to root_path, alert: '許可されていないリクエストです。'
        return
      end
    end
    # 退会済みユーザーは表示させない
    if @user.deleted_user
      redirect_to root_path, alert: '退会済みのユーザーです。'
      return
    end
    @stories = @user.stories.order(:created_at).reverse_order.page(params[:page]).per(10)
    @libraries = @user.libraries.count
    @visiteds = @user.visiteds.reverse
  end

  def index
    @users = User.order(:created_at).reverse_order.page(params[:page]).per(50).search(params[:search])
  end

  def admin_show
    @user = User.find(params[:id])
    @story_comments = @user.story_comments.order(:created_at).reverse_order
    @article_comments = @user.article_comments.order(:created_at).reverse_order
  end

  def admin_comments
    @article_comments = ArticleComment.order(:created_at).reverse_order.page(params[:page]).per(50).search(params[:search])
    @story_comments = StoryComment.order(:created_at).reverse_order.page(params[:page]).per(50).search(params[:search])
    @admin_comment_page = true
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: '利用者情報を更新しました。'
    else
      flash.now[:alert] = '利用者情報の更新に失敗しました。'
      render :show
    end
  end

  def unsubscribe
    @user = User.find(params[:id])
    @user.deleted_user = true
    @user.save
    if @user == current_user
      reset_session
      redirect_to root_path, alert: '退会しました。'
      return
    end
    redirect_to root_path
  end

  def unsubscribed_user?
    if user_signed_in?
      if current_user.deleted_user == true
        reset_session
        redirect_to root_path, alert: '退会済みのユーザーです。'
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :image, :caption)
  end

end
