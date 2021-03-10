class CreateCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :candidates do |t|
      t.string :city
      t.string :experience
      t.jsonb :technologies

      t.timestamps
    end

    add_index  :candidates, :technologies, using: :gin
  end
end
