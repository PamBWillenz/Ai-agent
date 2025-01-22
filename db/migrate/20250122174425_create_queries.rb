class CreateQueries < ActiveRecord::Migration[7.1]
  def change
    create_table :queries do |t|
      t.text :user_query
      t.text :ai_response

      t.timestamps
    end
  end
end
