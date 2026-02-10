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
      it 'returns the chosen colum' do
        allow(player).to receive(:gets).and_return('3')
        allow(board).to receive(:column_full?).and_return(false)
        expect(player.next_move).to be 2
      end
      it 'displays an error message if the column is full' do
        allow(player).to receive(:gets).and_return('3')
        allow(board).to receive(:column_full?).and_return(true, false)
        error_message = 'Please choose an available column'
        expect(player).to receive(:puts).with(error_message).once
        player.next_move
      end
    end
  end
end
