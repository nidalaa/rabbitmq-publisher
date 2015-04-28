class Currency < ActiveRecord::Base
  before_create :generate_key

  def generate_key
    self.key = SecureRandom.uuid
  end
end
