json.array!(@concerts) do |concert|
  json.extract! concert, :where, :year
  json.performers concert.performers
end