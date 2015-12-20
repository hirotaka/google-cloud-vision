class GoogleCloudVision
  attr_accessor :endpoint_uri, :file_path, :detection_type

  def initialize(file_path, detection_type)
    @endpoint_uri = "https://vision.googleapis.com/v1alpha1/images:annotate?key=#{ENV['SERVER_KEY']}"
    @file_path = file_path
    @detection_type = detection_type
  end

  def request
    http_client = HTTPClient.new
    content = Base64.strict_encode64(File.new(file_path, 'rb').read)
    response = http_client.post_content(endpoint_uri, request_json(content), 'Content-Type' => 'application/json')
    result_parse(response)
  end

  private

  def request_json(content)
    {
      requests: [{
        image: {
          content: content
        },
        features: [{
          type: "#{detection_type.upcase}_DETECTION",
          maxResults: 10
        }]
      }]
    }.to_json
  end

  def result_parse(response)
    result = JSON.parse(response)['responses'].first
    case detection_type
    when 'label'
      label = result['labelAnnotations'].first
      result = "これは、#{label['description']}です。"
    when 'text'
      text = result['textAnnotations'].first
      result = "これは、#{text['locale']}です。\n-----\n#{text['description']}"
    end
    result
  end
end
