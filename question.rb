require_relative 'question_pairs'

class Question < Database
  attr_accessor :id, :title, :body, :user_id
  
  def initialize(options = {})
    @id = options['question_id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def self.class_name
    "questions"
  end
  
  def self.class_id
    "question_id"
  end
  
  def author
    User.find_by_id(@user_id)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end
  
  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
  
  def likers
    QuestionLike.likers_for_question_id(@id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
  
  def followers
    QuestionFollower.followers_for_question_id(@id)
  end
    
end