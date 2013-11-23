class Podcast
  include DataMapper::Resource
  property :id,                  Serial
  property :title,               String,  length: 500, required: true
  property :rssurl,              URI,     format: :url, unique: true, required: true
  property :url,                 URI,     format: :url, required: true
  property :paused,              Boolean, default: false

  has n, :episodes, constraint: :destroy

  before :valid?, :set_url
  before :valid?, :set_rssurl

  def self.rssurls
    all(:fields => [:rssurl])
  end

  def set_url(context = :default)
    begin
      self.url = url.to_s.downcase
    rescue => e
      puts e
    end
  end

  def set_rssurl(context = :default)
    begin
      self.rssurl = rssurl.to_s.downcase
    rescue => e
      puts e
    end
  end

end


