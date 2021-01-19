# frozen_string_literal: true

module AssertionHelpers
  def check_error_response(response, expected)
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq expected.dig(:status)

    expected.each_key do |prop|
      expect(parsed_body.dig("error", prop.to_s)).to eql expected.dig(prop)
    end
  end
end
