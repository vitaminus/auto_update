require 'spec_helper'

describe AutoUpdate do
  it 'has a version number' do
    expect(AutoUpdate::VERSION).not_to be nil
  end

  it 'starwood login OK' do
    login_status = AutoUpdate::Starwood.login_with("44820011101", "sa!lb0at")
    puts login_status
    expect(login_status).to eq('login_ok')
  end

  it 'starwood login error' do
    login_status = AutoUpdate::Starwood.login_with("4482001110", "sa!lb0at")
    puts login_status
    expect(login_status[1]).to eq('error')
  end

  it 'starwood lockout error' do
    login_status = AutoUpdate::Starwood.login_with("vitaminus", "123A456b789C")
    puts login_status
    expect(login_status[1]).to eq('lockout')
  end

  # it 'starwood successfull update balance' do
  #   login = AutoUpdate::Starwood.login_with("44820011101", "sa!lb0at", '00C0DD1827B81cad1cad1553568350bf7d91df4')
  #   puts login
  #   expect(login).to eq([0, '00C0DD1827B81cad1cad1553568350bf7d91df4'])
  # end
end
