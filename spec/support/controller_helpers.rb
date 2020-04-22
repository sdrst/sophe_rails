module ControllerHelpers
  def expect_response_to_error_with(msg, status=422)
    expect(
      JSON.parse(response.body)
    ).to include("msg" => msg)
    expect(response.status).to eq(status)
  end
end
