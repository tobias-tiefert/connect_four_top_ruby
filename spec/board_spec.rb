# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }
  describe '#initialize_positions' do
    it 'creates an array' do
      test_board = board.initialize_positions
      expect(test_board).to be_a_kind_of Array
    end
    it 'creates an array with 7 entries' do
      test_board = board.initialize_positions
      expect(test_board.length).to be 7
    end
    it 'creates a 2-dimensional array' do
      test_board = board.initialize_positions
      expect(test_board.all? { |element| element.is_a?(Array) }).to be true
    end
    it 'the 2nd dimension arrays have 6 elements' do
      test_board = board.initialize_positions
      expect(test_board[1].length).to be 6
    end
    it 'all elements of the 2nd dimension are nil' do
      test_board = board.initialize_positions
      expect(test_board[5].all?(&:nil?)).to be true
    end
  end

  describe '#column_full?' do
    it 'returns false, when the column is not full' do
      expect(board.column_full?(0)).to be false
    end
    it 'returns true, when the column is  full' do
      board.positions[1][5] = 'placeholder'
      expect(board.column_full?(1)).to be true
    end
  end

  describe '#free_position' do
    it 'returns the available position when the column is emtpy' do
      expect(board.free_position(2)).to be 0
    end
    it 'returns the available position when the column is not empty' do
      3.times do |row|
        board.positions[1][row] = 'placeholder'
      end
      expect(board.free_position(1)).to be 3
    end
    it "doesn't do anything if the column is full" do
      6.times do |row|
        board.positions[1][row] = 'placeholder'
      end
      expect(board.free_position(1)).to be nil
    end
  end

  describe '#drop_token' do
    let(:dummy_token) { double('token') }
    before(:each) do
      allow(dummy_token).to receive(:position=)
    end
    context 'when a column is not full, it drops the token at the lowest position' do
      it 'works with an empty column' do
        board.drop_token(dummy_token, 0)
        drop_position = board.positions[0][0]
        expect(drop_position).to be dummy_token
      end
      it 'works with a column that already has tokens' do
        3.times do |row|
          board.positions[1][row] = 'placeholder'
        end
        board.drop_token(dummy_token, 1)
        drop_position = board.positions[1][3]
        expect(drop_position).to be dummy_token
      end
      it 'gives the token a position' do
        expect(dummy_token).to receive(:position=).with({ x: 5, y: 0 })
        board.drop_token(dummy_token, 5)
      end
    end
    context 'when a column is full' do
      it "doesn't work with a column that is full" do
        6.times do |row|
          board.positions[5][row] = 'placeholder'
        end
        length_before = board.positions[1].length
        board.drop_token(dummy_token, 1)
        length_after = board.positions[1].length
        expect(length_after).to be length_before
      end
      it "doesn't give the token a position" do
        6.times do |row|
          board.positions[5][row] = 'placeholder'
        end
        expect(dummy_token).not_to receive(:position=).with({ x: 5, y: 0 })
        board.drop_token(dummy_token, 5)
      end
    end
  end

  describe '#full?' do
    context 'if the board is not full' do
      it 'returns false for an empty board' do
        expect(board.full?).to be false
      end
      it "returns false for a board that's almost full" do
        6.times do |column|
          6.times do |row|
            board.positions[column][row] = 'placeholder'
          end
        end
        expect(board.full?).to be false
      end
    end
    context 'if the board is full' do
      before do
        7.times do |column|
          6.times do |row|
            board.positions[column][row] = 'placeholder'
          end
        end
      end
      it 'returns true' do
        expect(board.full?).to be true
      end
    end
  end
end
