require 'dotenv'
Dotenv.load
require 'aws-sdk'
client = Aws::Rekognition::Client.new
resp = client.detect_labels(image: { bytes: File.read(ARGV.first) })

human_labels = %w[Human People Person]
human = 'It is a human'
not_human = 'It is not a human'

text = not_human

resp.labels.each do |label|
  if human_labels.include?(label.name)
    text = human
    break
  end
end

puts text