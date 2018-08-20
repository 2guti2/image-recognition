module Api
  class ImagesController < ApplicationController
    def create
      image = image_params

      require 'dotenv'
      Dotenv.load
      require 'aws-sdk'
      client = Aws::Rekognition::Client.new

      i = image[:base64String]
      data = i[i.index("base64,") + "base64,".size, i.size]

      File.open('image.png', 'wb') do |f|
        f.write(Base64.decode64(data))
      end

      resp = client.detect_labels(image: { bytes: File.read('image.png') })

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

      render json: {response: text}, status: :ok
    end

    def image_params
      params.require(:image).permit(:base64String)
    end

    class Image

    end
  end
end
