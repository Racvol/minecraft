class PagesController < ApplicationController


  def home
    @posts = Post.all(:limit => 6).reverse
    @post = Post.new
  end

  def faq
  end

end

