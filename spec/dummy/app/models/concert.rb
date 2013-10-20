class Concert < ActiveRecord::Base
  has_and_belongs_to_many :performers, join_table: 'artists_concerts',
    foreign_key: 'concert_id', class_name: 'Artist'

  validates_presence_of :where

  def self.filter(filters = {})
    filters.inject(all) do |where_chain, filter|
      key, value = filter
      scope = valid_filters.fetch key.to_sym, -> _ {[:instance_eval, 'self']}
      where_chain.send *(scope.call value)
    end
  end

  def self.sort(sorting)
    case sorting
      when 'time' then order(year: :asc)
      when '-time' then order(year: :desc)
      else all
    end
  end

private

  def self.valid_filters
    {
      location: -> location { [:where, ['lower(`where`) = ?', location.downcase]] },
      when: -> year { [:where, year: year] }
    }
  end
end