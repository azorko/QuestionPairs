require_relative 'question_pairs'

class User < Database
  attr_accessor :id, :fname, :lname
  def self.class_name
    "users"
  end
  def self.class_id
    "user_id"
  end
  
  def initialize(options = {})
     @id = options['user_id']
     @fname = options['fname']
     @lname = options['lname']
   end
  
  def save
    if @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
        INSERT INTO
          users
          (fname, lname)
        VALUES
          (? , ?)
      SQL
      
    else
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
        UPDATE
          users
        SET
          (fname = ?, lname = ?)
        WHERE
          id = #{@id}
      SQL
    end
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.get_first_row(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?
      AND
        lname = ?
    SQL
    new(result)
  end
  
  def average_karma
    result = QuestionsDatabase.instance.get_first_row(<<-SQL, @id) 
      SELECT 
        CAST(COUNT(ql.user_id) AS FLOAT) / COUNT(DISTINCT q.question_id)
      FROM 
        question_likes ql 
      JOIN 
        questions q 
      ON 
        (ql.question_id = q.question_id)
      WHERE q.user_id = @id
    SQL
    result.values.first
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end
  
  def authored_questions
    results = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end

end

user = User.new({'fname' => "Andrew", 'lname' => "Zorko"})
user.save

p User.all