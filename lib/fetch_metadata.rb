class FetchMetadata
  @queue = :fetch_metadata

  def self.perform(vurl_id)
    vurl = Vurl.find_by_id(vurl_id)
    vurl && vurl.fetch_metadata
  end
end
