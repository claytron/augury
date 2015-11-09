require 'spec_helper'

describe Augury do
  it 'has a version number' do
    expect(Augury::VERSION).not_to be nil
  end

  it 'loads the code of the app to show the poor test coverage' do
    Augury::Fortune.new('SeinfeldToday', '/tmp/funny')
    # Best test evar
    expect(true).to eq(true)
  end
end
