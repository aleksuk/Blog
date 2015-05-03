class Base < ActiveRecord::Base

  protected

  def reindex!
    Sunspot.index!(self)
  end

end