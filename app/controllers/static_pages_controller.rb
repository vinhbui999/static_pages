class StaticPagesController < ApplicationController
  def home
    # reset_session
    if logged_in? 
      @microposts = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
    end
  end

  def help
  end

  def about
  end
  
  def contact
  end
end
