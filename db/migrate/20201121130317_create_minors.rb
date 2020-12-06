class CreateMinors < ActiveRecord::Migration[6.0]
  def change
    create_table :minors do |t|
      t.string :title
      t.integer :faculty_id
      t.integer :kredits
      t.text :deskription
      t.string :location
      t.string :page_url

      t.timestamps
    end
  end
end
