require "./spec_helper"

describe HIDAPI do
  it "#version" do
    hidapi = HIDAPI.new
    hidapi.version.should match(/\d+\.\d+\.\d+/)
  end
end
