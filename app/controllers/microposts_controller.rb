class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user, only: [:destroy]
    def create
        @microposts = current_user.microposts.build(micropost_params)
        @microposts.image.attach(params[:micropost][:image])
        #this for create new post by logged in user
        if @microposts.save
            flash[:success] = "Micropost created!"
            redirect_to root_path
        else
            @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
            render 'static_pages/home'
        end
    end

    def destroy
        @micropost.destroy
        flash[:success] = "Micropost deleted"
        redirect_to request.referrer || root_url
    end

    private
    def micropost_params
        params.require(:micropost).permit(:content, :image)
    end

    def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_path if @micropost.nil?
    end
end
