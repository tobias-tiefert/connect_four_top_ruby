# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/token'

describe Player do
  before(:each) do
    allow(player).to receive(:puts)
  end
  let(:board) { double('board') }
  subject(:player) { described_class.new('Player1', 'blue', board) }
  let(:token) { double('token', color: 'blue') }
  describe '#next_move' do
    context 'when the player is asked for her next move' do
      it 'calls drop_token on the board object' do
        allow(player).to receive(:gets).and_return('3')
        allow(token).to receive(:new)
        expect(board).to receive(:drop_token)
        player.next_move
      end
    end
  end
end
