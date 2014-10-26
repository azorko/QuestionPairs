require_relative 'question_pairs'

class Reply < Database
  attr_accessor :id, :question_id, :parent_id, :user_id, :body
  
  def self.class_name
    "replies"
  end
  
  def self.class_id
    "reply_id"
  end
  
  def initialize(options = {})
    @id = options['reply_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end
  
  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end
  
  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end
  
  def author
    result = QuestionsDatabase.instance.get_first_row(<<-SQL, @user_id)
      SELECT
        *
      FROM
        users
      WHERE
        user_id = ?
    SQL

    User.new(result)
  end
  
  def question
    result = QuestionsDatabase.instance.get_first_row(<<-SQL, @question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        question_id = ?
    SQL

    Question.new(result)
  end
  
  def parent_reply
    result = QuestionsDatabase.instance.get_first_row(<<-SQL, @parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
    SQL

    Reply.new(result)
  end
  
  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL

    results.map { |result| Reply.new(result) }
  end
  
end