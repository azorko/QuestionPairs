require_relative 'question_pairs'

class QuestionFollower < Database
  attr_accessor :id, :question_id, :user_id
  
  def self.class_name
    "questionfollowers"
  end
  
  def self.class_id
    "questionfollower_id"
  end
  
  def initialize(options = {})
    @id = options['questionfollower_id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
  
  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        u.user_id, u.fname, u.lname
      FROM
        question_followers q JOIN users u ON (q.user_id = u.user_id)
      WHERE
        q.question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        u.question_id, u.title, u.body, u.user_id
      FROM
        question_followers q JOIN questions u ON (q.question_id = u.question_id)
      WHERE
        q.user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end
  
  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        qf.question_id, q.title, q.body, q.user_id
      FROM
        question_followers qf
      JOIN
        questions q
      ON
        (qf.question_id = q.question_id)
      GROUP BY
        qf.question_id
      ORDER BY
        COUNT(qf.question_id) DESC
    SQL

    results.map { |result| Question.new(result) }.take(n)
  end
  
end