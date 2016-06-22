class Ping

  include JsonapiForRails::Model

  def attributes
    { pong: pong }
  end

  def id
    nil
  end

  def pong
    Time.current.to_s
  end

  def self.find_by_id(id)
    Ping.new
  end

  def self.reflect_on_all_associations
    []
  end

end
