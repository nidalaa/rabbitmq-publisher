class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.uuid :key
      t.json :rates
      t.boolean :consumer_ack1
      t.boolean :consumer_ack2
      t.boolean :consumer_ack3

      t.timestamps null: false
    end
  end
end
