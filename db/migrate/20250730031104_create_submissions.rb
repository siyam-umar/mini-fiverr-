class CreateSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :submissions do |t|
      t.references :order, null: false, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
