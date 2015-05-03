module Reindex
  extend ActiveSupport::Concern

  included do
    after_create :reindex!
    after_update :reindex!
  end

  def reindex!
    Sunspot.index!(self)
  end
end