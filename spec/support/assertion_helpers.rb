# frozen_string_literal: true

module AssertionHelpers
  def check_error_response(response, expected)
    parsed_body = JSON.parse(response.body)

    expect(response.code).to eql expected.dig(:code).to_s
    expect(parsed_body.dig("error", "status")).to eql expected.dig(:code)
    expect(parsed_body.dig("error", "message")).to eql expected.dig(:message)
  end
end
