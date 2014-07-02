class CreateDiggs < ActiveRecord::Migration
  def change
    create_table :diggs do |t|
      t.string :content_id

      t.timestamps
    end
  end
end
