class PostsController < ApplicationController

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      respond_to do |format|
      format.js
    end
    else
    render 'pages/home'
    end

  end

end

