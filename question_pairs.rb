require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  def initialize
    super("questions.db")
    # Typically each row is returned as an array of values; it's more
    # convenient for us if we receive hashes indexed by column name.
    self.results_as_hash = true

    # Typically all the data is returned as strings and not parsed
    # into the appropriate type.
    self.type_translation = true
  end
end

class Database
  def self.all
    # execute a SELECT; result in an `Array` of `Hash`es, each
    # represents a single row.
    results = QuestionsDatabase.instance.execute("SELECT * FROM #{class_name}")
    results.map { |result| new(result) }
  end
  
  def self.find_by_id(id)
    results = QuestionsDatabase.instance.get_first_row(
    "SELECT
        *
      FROM
      #{class_name}
      WHERE
      #{class_id} = #{id}")

    new(results)
  end
end



