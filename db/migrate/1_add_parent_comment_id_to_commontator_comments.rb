class AddParentCommentIdToCommontatorComments < ActiveRecord::Migration
  def change
    change_table :commontator_comments do |t|
      t.integer :parent_comment_id
    end

    add_index :commontator_comments, :parent_comment_id
  end
end

