class Podcast
  include DataMapper::Resource

  property :id,                  Serial
  property :title,               String,  length: 500, unique: true
  property :rssurl,              URI,     format: :url, unique: true
  property :url,                 URI,     format: :url, unique: true
  property :paused,              Boolean, default: false

  has n, :episodes, constraint: :destroy
end


