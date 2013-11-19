class Episode
  include DataMapper::Resource

  property :id,             Serial
  property :title,          String,   length: 500
  property :url,            URI,      format: :url, unique: true
  property :enclosure_url,  URI,      format: :url, unique: true
  property :downloaded,     Boolean,  default: false
  property :pub_date,       DateTime

  belongs_to :podcast

  def mark_as_downloaded
    self.downloaded = true
    success = save
    if !success
      errors.each do |error|
        puts error
      end
    end
  end
end



