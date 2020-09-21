module ApplicationHelper
  def daytime_localize(daytime)
    daytime.strftime("%Y年%m月%d日 %H:%M:%S")
  end
end
