class Post < ActiveRecord::Base
  attr_accessible :content
#Устанавливам свять чата с пользователями
  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

#Сортируем по убыванию
  default_scope :order => 'posts.created_at DESC'
end

