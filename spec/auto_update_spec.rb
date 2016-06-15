require 'spec_helper'

describe AutoUpdate do
  it 'has a version number' do
    expect(AutoUpdate::VERSION).not_to be nil
  end

  it 'starwood login OK' do
    response = AutoUpdate::Starwood.login_with("44820011101", "sa!lb0at")
    # puts response
    expect(response).to eq(AutoUpdate::STATUS_LOGIN_OK)
  end

  it 'starwood login error' do
    response = AutoUpdate::Starwood.login_with("4482001110", "sa!lb0at")
    # puts response
    expect(response[:state]).to eq('2')
    expect(response[:message]).to eq('Incorrect login or password')
    expect(response[:error_message]).not_to be_empty
  end

  it 'starwood lockout error' do
    response = AutoUpdate::Starwood.login_with("vitaminus", "123A456b789C")
    puts response
    expect(response[:state]).to eq('3')
    expect(response[:message]).to eq('LOCKOUT')
    expect(response[:error_message]).not_to be_empty
  end

  it 'starwood sent a question' do
    AutoUpdate::Starwood.login_with("44820011101", "sa!lb0at")
    response = AutoUpdate::Starwood.send_question
    expect(response).not_to be_empty
  end

  it 'starwood wrong answare to question' do
    AutoUpdate::Starwood.login_with("44820011101", "sa!lb0at")
    AutoUpdate::Starwood.send_question
    response = AutoUpdate::Starwood.answare_to_question "londo"
    expect(response[0]).to eq(AutoUpdate::STATUS_WRONG_ANSWER)
    expect(response[1]).not_to be_empty
    expect(response[2]).not_to be_empty
  end

  it 'starwood correct answare to question and get balance' do
    AutoUpdate::Starwood.login_with("44820011101", "sa!lb0at")
    question = AutoUpdate::Starwood.send_question
    puts question
    answare =
      case question
      when 'What tops your travel wish list?'
        'london'
      when 'What is your favorite type of food?'
        'sea'
      when 'What was the name of your first pet?'
        'candy'
      when 'What is your favorite vacation destination?'
        'sydney'
      end
    puts answare
    response = AutoUpdate::Starwood.answare_to_question answare
    puts response
    expect(response[:state]).to eq('1')
    expect(response[:balance]).to eq(0)
    expect(response[:device_id]).not_to be_empty
  end

  it 'starwood has device_id get balance' do
    response = AutoUpdate::Starwood.login_with("44820011101", "sa!lb0at", "E61F13F7E83B354a354a15539c51bc4e8ed0c30")
    puts response
    expect(response[:state]).to eq('1')
    expect(response[:device_id]).to eq("E61F13F7E83B354a354a15539c51bc4e8ed0c30")
    expect(response[:balance]).to eq(0)
  end

  # it 'starwood successfull update balance' do
  #   login = AutoUpdate::Starwood.login_with("44820011101", "sa!lb0at", '00C0DD1827B81cad1cad1553568350bf7d91df4')
  #   puts login
  #   expect(login).to eq([0, '00C0DD1827B81cad1cad1553568350bf7d91df4'])
  # end
end
