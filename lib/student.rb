require 'pry'
require_relative "../config/environment.rb"
# Remember, you can access your database connection anywhere in this class
#  with DB[:conn]

class Student


  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @id, @name, @grade = id, name, grade
  end

  def self.create_table
    sql = <<-SQL
      create table if not exists students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
      sql = <<-SQL
        drop table if exists students
      SQL
      DB[:conn].execute(sql)
  end

    def save
      if self.id
        self.update
      else
      sql = <<-SQL
        INSERT INTO students(name, grade) VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("select last_insert_rowid() from students")[0][0]
    end
  end

    def update
      sql = <<-SQL
        UPDATE students SET name = ?, grade = ? where id = ?
      SQL
        DB[:conn].execute(sql, self.name, self.grade, self.id)
    end

    def self.create(name, grade)
      student=Student.new(name, grade)
      student.save
    end

    def self.new_from_db(row)
      id, name, grade = row
      new_student = Student.new(id, name, grade)
    end

    def self.find_by_name(name)
      sql = <<-SQL
        select * from students where name = ?
        limit 1
      SQL
      row=DB[:conn].execute(sql, name).flatten
      self.new_from_db(row)
    end


end
