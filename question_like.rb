require_relative 'question_pairs'

class QuestionLike < Database
  attr_accessor :id, :question_id, :user_id, :body
  
  def self.class_name
    "questionlikes"
  end
  
  def self.class_id
    "questionlike_id"
  end
  
  def initialize(options = {})
    @id = options['questionlike_id']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @body = options['body']
  end
  
  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
      u.user_id, u.fname, u.lname
      FROM
        users u
      JOIN
        question_likes q ON (u.user_id = q.user_id)
      WHERE
        q.question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end
  
  def self.num_likes_for_question_id(question_id)
    result = QuestionsDatabase.instance.get_first_row(<<-SQL, question_id)
      SELECT
        COUNT(user_id)
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL
    result.values.first
  end
  
  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
      q.question_id, q.title, q.body, q.user_id
      FROM
        questions q
      JOIN
        question_likes ql ON (q.question_id = ql.question_id)
      WHERE
        ql.user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end
  
  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        ql.question_id, q.title, q.body, q.user_id
      FROM
        question_likes ql
      JOIN
        questions q
      ON
        (ql.question_id = q.question_id)
      GROUP BY
        ql.question_id
      ORDER BY
        COUNT(ql.question_id) DESC
    SQL

    results.map { |result| Question.new(result) }.take(n)
  end
  
end
