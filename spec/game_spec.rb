# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }
  describe '#game_over?' do
    it 'returns false if @winner is not defined' do
      expect(game.game_over?).to be false
    end
    it 'returns true if @winner is defined' do
      game.instance_variable_set(:@winner, 'test')
      expect(game.game_over?).to be true
    end
  end
  describe '#switch_players' do
    it 'switches the players' do
      player_before = game.instance_variable_get(:@current_player)
      game.switch_players
      player_after = game.instance_variable_get(:@current_player)
      expect(player_before).not_to be player_after
    end
  end
end
