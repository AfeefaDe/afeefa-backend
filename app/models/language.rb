class Language < ActiveRecord::Base

  validates_presence_of :code
  validates_length_of :code, minimum: 2

end
