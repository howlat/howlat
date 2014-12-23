class AddParametersToMessage < ActiveRecord::Migration
  def change
    change_table :messages do |t|
      t.json :parameters
    end
  end
end
