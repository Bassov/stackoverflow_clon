class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :body
      t.string :text

      t.belongs_to :question, index: true

      t.timestamps null: false
    end
  end
end
