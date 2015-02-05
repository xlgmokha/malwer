class FakeAgent
  attr_reader :id, :endpoint

  def initialize(id, endpoint)
    @id = id
    @endpoint = endpoint
  end

  def run(directory)
    listener = Listen.to(directory, debug: true) do |modified, added, removed|
      publish_event(:modified, modified)
      publish_event(:added, added)
      publish_event(:removed, removed)
    end

    listener.start
    sleep
  end

  private

  def publish_event(event, files)
    files.each do |file|
      fingerprint = fingerprint_for(file)
      url = "#{endpoint}/agents/#{id}/events/"
      body = {
        event: {
          agent_id: id,
          name: event,
          data: {
            fingerprint: fingerprint,
            full_path: file,
          }
        }
      }
      puts [url, body].inspect
      Typhoeus.post(url, body: body)
    end
  rescue => e
    puts "#{e.message} #{e.backtrace.join(' ')}"
  end

  def fingerprint_for(file)
    return nil unless File.exist?(file)
    result = `shasum -a 256 #{file}`
    sha, * = result.split(' ')
    sha
  end
end
