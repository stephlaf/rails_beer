class FetchImage
  def initialize(uri)
    @uri = uri
  end

  def download_to_file
    begin
      stream = URI.open(@uri, "rb")
      return stream if stream.respond_to?(:path) # Already file-like
    rescue OpenURI::HTTPError
      return File.open(File.join(Rails.root, "/app/assets/images/default_beer.png"))
    end

    Tempfile.new.tap do |file|
      file.binmode
      IO.copy_stream(stream, file)
      stream.close
      file.rewind
    end
  end
end
