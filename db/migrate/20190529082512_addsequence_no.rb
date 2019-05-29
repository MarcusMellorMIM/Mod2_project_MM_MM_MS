class AddsequenceNo < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :sequence_no, :integer
  end
end
