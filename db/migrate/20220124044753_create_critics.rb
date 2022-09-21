class CreateCritics < ActiveRecord::Migration[7.0]
  def change
    create_table :critics do |t|
      t.string :title
      t.text :body
      t.boolean :approve, default: false
      t.references :user, null: false, foreign_key: true
      t.references :criticable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
