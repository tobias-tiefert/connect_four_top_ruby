# frozen_string_literal: true

require_relative '../lib/token'

describe Token do
  let(:board) { double('board') }
  subject(:token) { described_class.new('green') }
  describe '#on_the_board?' do
    context 'checks if a given position is on the board' do
      it 'retruns true for a position on the board' do
        expect(token.on_the_board?(1, 2)).to be true
      end
      it 'retruns true for the min position on the board (0,0)' do
        expect(token.on_the_board?(0, 0)).to be true
      end
      it 'retruns true for the max position on the board (6,5)' do
        expect(token.on_the_board?(6, 5)).to be true
      end
      it 'retruns false for a negative y position' do
        expect(token.on_the_board?(1, -2)).to be false
      end
      it 'retruns false for a negative x position' do
        expect(token.on_the_board?(-1, 2)).to be false
      end
      it 'retruns false for a negative x and negative y position' do
        expect(token.on_the_board?(-1, -2)).to be false
      end
      it 'retruns false for a x position higher than the number of columns' do
        expect(token.on_the_board?(7, 2)).to be false
      end
      it 'retruns false for a y position higher than the number of rows' do
        expect(token.on_the_board?(3, 6)).to be false
      end
    end
  end
  describe '#create_sign' do
    context 'creates the sign with the given color' do
      it 'creates green' do
        sign = token.create_sign('green')
        expect(sign).to eq("\e[92m◉\e[90m")
      end
      it 'creates blue' do
        sign = token.create_sign('blue')
        expect(sign).to eq("\e[94m◉\e[90m")
      end
      it 'creates yellow' do
        sign = token.create_sign('yellow')
        expect(sign).to eq("\e[93m◉\e[90m")
      end
      it 'creates red' do
        sign = token.create_sign('red')
        expect(sign).to eq("\e[91m◉\e[90m")
      end
      it 'creates purple' do
        sign = token.create_sign('purple')
        expect(sign).to eq("\e[95m◉\e[90m")
      end
      it 'creates white when nothing is given' do
        sign = token.create_sign
        expect(sign).to eq("\e[107m◉\e[90m")
      end
      it 'creates white when there is a typo' do
        sign = token.create_sign('grean')
        expect(sign).to eq("\e[107m◉\e[90m")
      end
    end
  end

  describe '#neighbour' do
    let(:new_token) { described_class.new('green') }

    it "updates the token's neighbour to a given value" do
      token.neighbour(new_token, :up)
      neighbours = token.instance_variable_get(:@neighbours)
      up = neighbours[:up]
      expect(up).to be new_token
    end
  end

  describe '#all_neighbours' do
    let(:neighbours_board) { double('board') }
    before(:each) do
      token.position = { x: 0, y: 0 }
      token_one = Token.new('green')
      token_two = Token.new('blue')
      board_positions = [
        [token, token_one, nil, nil, nil, nil],
        [token_two, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil]
      ]
      allow(neighbours_board).to receive(:positions).and_return(board_positions)
    end
    it 'calls the neighbour method twice' do
      expect(token).to receive(:neighbour).twice
      token.all_neighbours(neighbours_board.positions)
    end
    it 'updates the postion for the up neighbour' do
      token.all_neighbours(neighbours_board.positions)
      token_neighbours = token.instance_variable_get(:@neighbours)
      expect(token_neighbours[:up]).to be_a_kind_of Token
    end
    it 'makes the up neighbour of color green' do
      token.all_neighbours(neighbours_board.positions)
      token_neighbours = token.instance_variable_get(:@neighbours)
      expect(token_neighbours[:up].color).to be('green')
    end
    it 'updates the postion for the right neighbour' do
      token.all_neighbours(neighbours_board.positions)
      token_neighbours = token.instance_variable_get(:@neighbours)
      expect(token_neighbours[:right]).to be_a_kind_of Token
    end
    it 'makes the right neighbour of color blue' do
      token.all_neighbours(neighbours_board.positions)
      token_neighbours = token.instance_variable_get(:@neighbours)
      expect(token_neighbours[:right].color).to be('blue')
    end
    it 'leaves the up_right neighbour nil' do
      token.all_neighbours(neighbours_board.positions)
      token_neighbours = token.instance_variable_get(:@neighbours)
      expect(token_neighbours[:up_right]).to be nil
    end
    it "it changes the  up's neighbour's down neighbour to self" do
      token.all_neighbours(neighbours_board.positions)
      up_neighbour = token.instance_variable_get(:@neighbours)[:up]
      expect(up_neighbour.neighbours[:down]).to be token
    end
  end

  describe '#connect_four?' do
    context 'when four tokens of the same color are connected' do
      subject(:first) { described_class.new('green') }
      subject(:second) { described_class.new('green') }
      subject(:third) { described_class.new('green') }
      subject(:fourth) { described_class.new('green') }

      it 'returns true for 4 in a row' do
        first.position = { x: 0, y: 0 }
        second.position = { x: 1, y: 0 }
        third.position = { x: 2, y: 0 }
        fourth.position = { x: 3, y: 0 }
        first.instance_variable_set(:@neighbours, {
                                      up: nil,
                                      up_right: nil,
                                      right: second,
                                      down_right: nil,
                                      down: nil,
                                      down_left: nil,
                                      left: nil,
                                      up_left: nil
                                    })
        second.instance_variable_set(:@neighbours, {
                                       up: nil,
                                       up_right: nil,
                                       right: third,
                                       down_right: nil,
                                       down: nil,
                                       down_left: nil,
                                       left: first,
                                       up_left: nil
                                     })
        third.instance_variable_set(:@neighbours, {
                                      up: nil,
                                      up_right: nil,
                                      right: fourth,
                                      down_right: nil,
                                      down: nil,
                                      down_left: nil,
                                      left: second,
                                      up_left: nil
                                    })
        fourth.instance_variable_set(:@neighbours, {
                                       up: nil,
                                       up_right: nil,
                                       right: nil,
                                       down_right: nil,
                                       down: nil,
                                       down_left: nil,
                                       left: third,
                                       up_left: nil
                                     })
        expect(third.connect_four?).to be true
      end
      it 'returns true for 4 in a column' do
        first.position = { x: 0, y: 0 }
        second.position = { x: 0, y: 1 }
        third.position = { x: 0, y: 2 }
        fourth.position = { x: 0, y: 3 }
        first.instance_variable_set(:@neighbours, {
                                      up: second,
                                      up_right: nil,
                                      right: nil,
                                      down_right: nil,
                                      down: nil,
                                      down_left: nil,
                                      left: nil,
                                      up_left: nil
                                    })
        second.instance_variable_set(:@neighbours, {
                                       up: third,
                                       up_right: nil,
                                       right: nil,
                                       down_right: nil,
                                       down: first,
                                       down_left: nil,
                                       left: nil,
                                       up_left: nil
                                     })
        third.instance_variable_set(:@neighbours, {
                                      up: fourth,
                                      up_right: nil,
                                      right: nil,
                                      down_right: nil,
                                      down: second,
                                      down_left: nil,
                                      left: nil,
                                      up_left: nil
                                    })
        fourth.instance_variable_set(:@neighbours, {
                                       up: nil,
                                       up_right: nil,
                                       right: nil,
                                       down_right: nil,
                                       down: third,
                                       down_left: nil,
                                       left: nil,
                                       up_left: nil
                                     })
        expect(third.connect_four?).to be true
      end
      it 'returns true for 4 in diagonale' do
        first.position = { x: 0, y: 0 }
        second.position = { x: 1, y: 1 }
        third.position = { x: 2, y: 2 }
        fourth.position = { x: 3, y: 3 }
        first.instance_variable_set(:@neighbours, {
                                      up: nil,
                                      up_right: second,
                                      right: nil,
                                      down_right: nil,
                                      down: nil,
                                      down_left: nil,
                                      left: nil,
                                      up_left: nil
                                    })
        second.instance_variable_set(:@neighbours, {
                                       up: nil,
                                       up_right: third,
                                       right: nil,
                                       down_right: nil,
                                       down: nil,
                                       down_left: first,
                                       left: nil,
                                       up_left: nil
                                     })
        third.instance_variable_set(:@neighbours, {
                                      up: nil,
                                      up_right: fourth,
                                      right: nil,
                                      down_right: nil,
                                      down: nil,
                                      down_left: second,
                                      left: nil,
                                      up_left: nil
                                    })
        fourth.instance_variable_set(:@neighbours, {
                                       up: nil,
                                       up_right: nil,
                                       right: nil,
                                       down_right: nil,
                                       down: nil,
                                       down_left: third,
                                       left: nil,
                                       up_left: nil
                                     })
        expect(third.connect_four?).to be true
      end
    end
    context "when there aren't four connected tokens of the same color" do
      subject(:first) { described_class.new('green') }
      subject(:second) { described_class.new('red') }
      subject(:third) { described_class.new('green') }
      subject(:fourth) { described_class.new('green') }

      it 'returns false for 4 in a row' do
        first.position = { x: 0, y: 0 }
        second.position = { x: 1, y: 0 }
        third.position = { x: 2, y: 0 }
        fourth.position = { x: 3, y: 0 }
        first.instance_variable_set(:@neighbours, {
                                      up: nil,
                                      up_right: nil,
                                      right: second,
                                      down_right: nil,
                                      down: nil,
                                      down_left: nil,
                                      left: nil,
                                      up_left: nil
                                    })
        second.instance_variable_set(:@neighbours, {
                                       up: nil,
                                       up_right: nil,
                                       right: third,
                                       down_right: nil,
                                       down: nil,
                                       down_left: nil,
                                       left: first,
                                       up_left: nil
                                     })
        third.instance_variable_set(:@neighbours, {
                                      up: nil,
                                      up_right: nil,
                                      right: fourth,
                                      down_right: nil,
                                      down: nil,
                                      down_left: nil,
                                      left: second,
                                      up_left: nil
                                    })
        fourth.instance_variable_set(:@neighbours, {
                                       up: nil,
                                       up_right: nil,
                                       right: nil,
                                       down_right: nil,
                                       down: nil,
                                       down_left: nil,
                                       left: third,
                                       up_left: nil
                                     })
        expect(third.connect_four?).to be false
      end
      it 'returns false for 4 in a column' do
        first.position = { x: 0, y: 0 }
        second.position = { x: 0, y: 1 }
        third.position = { x: 0, y: 2 }
        fourth.position = { x: 0, y: 3 }
        first.instance_variable_set(:@neighbours, {
                                      up: second,
                                      up_right: nil,
                                      right: nil,
                                      down_right: nil,
                                      down: nil,
                                      down_left: nil,
                                      left: nil,
                                      up_left: nil
                                    })
        second.instance_variable_set(:@neighbours, {
                                       up: third,
                                       up_right: nil,
                                       right: nil,
                                       down_right: nil,
                                       down: first,
                                       down_left: nil,
                                       left: nil,
                                       up_left: nil
                                     })
        third.instance_variable_set(:@neighbours, {
                                      up: fourth,
                                      up_right: nil,
                                      right: nil,
                                      down_right: nil,
                                      down: second,
                                      down_left: nil,
                                      left: nil,
                                      up_left: nil
                                    })
        fourth.instance_variable_set(:@neighbours, {
                                       up: nil,
                                       up_right: nil,
                                       right: nil,
                                       down_right: nil,
                                       down: third,
                                       down_left: nil,
                                       left: nil,
                                       up_left: nil
                                     })
        expect(third.connect_four?).to be false
      end
      it 'returns false for 4 in diagonale' do
        first.position = { x: 0, y: 0 }
        second.position = { x: 1, y: 1 }
        third.position = { x: 2, y: 2 }
        fourth.position = { x: 3, y: 3 }
        first.instance_variable_set(:@neighbours, {
                                      up: nil,
                                      up_right: second,
                                      right: nil,
                                      down_right: nil,
                                      down: nil,
                                      down_left: nil,
                                      left: nil,
                                      up_left: nil
                                    })
        second.instance_variable_set(:@neighbours, {
                                       up: nil,
                                       up_right: third,
                                       right: nil,
                                       down_right: nil,
                                       down: nil,
                                       down_left: first,
                                       left: nil,
                                       up_left: nil
                                     })
        third.instance_variable_set(:@neighbours, {
                                      up: nil,
                                      up_right: fourth,
                                      right: nil,
                                      down_right: nil,
                                      down: nil,
                                      down_left: second,
                                      left: nil,
                                      up_left: nil
                                    })
        fourth.instance_variable_set(:@neighbours, {
                                       up: nil,
                                       up_right: nil,
                                       right: nil,
                                       down_right: nil,
                                       down: nil,
                                       down_left: third,
                                       left: nil,
                                       up_left: nil
                                     })
        expect(third.connect_four?).to be false
      end
    end
  end
end
