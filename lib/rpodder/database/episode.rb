class Episode
  include DataMapper::Resource

  property :id,             Serial
  property :title,          String,   length: 500, required: true
  property :url,            URI,      format: :url, unique: true, required: true
  property :enclosure_url,  URI,      format: :url, unique: true, required: true
  property :downloaded,     Boolean,  default: false
  property :pub_date,       DateTime

  belongs_to :podcast

  def self.new_episodes
    all(:downloaded => false, :podcast => { :paused => false })
  end

  def mark_as_downloaded
    self.downloaded = true
    success = save
    if !success
      errors.each do |error|
        $stderr.puts error
      end
    end
  end

  before :valid?, :set_url
  before :valid?, :set_enclosure_url

  def set_url(context = :default)
    begin
      self.url = url.to_s.downcase
    rescue => e
      puts e
    end
  end

  def set_enclosure_url(context = :default)
    begin
      # Youtube feeds don't have a enclosure_url so we just use the url.
      self.enclosure_url = url if self.enclosure_url.nil?
      self.enclosure_url = enclosure_url.to_s.downcase
    rescue => e
      puts e
    end
  end
end
