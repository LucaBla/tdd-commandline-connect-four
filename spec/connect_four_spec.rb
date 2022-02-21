require './connect_four.rb'
require './player.rb'

describe ConnectFour do
  subject(:game) { described_class.new }
  let(:player) { double(Player) }

  describe '#validate_input' do
    context 'When input is valid' do
      it 'returns true' do
        valid_input = 6
        expect(game.validate_input(valid_input)).to be true
      end
    end

    context 'When input is not valid' do
      it 'returns false' do
        not_valid_input = [20, 20]
        expect(game.validate_input(not_valid_input)).to be false
      end
    end
  end

  describe '#marks_in_column' do
    context 'when column is empty' do
      it 'returns 0' do
        column = 2
        expect(game.marks_in_column(column)).to eq(0)
      end
    end

    context 'when column is not empty, but filled with one element' do
      before do
        red_circle = "\e[31m\u25cf"
        column = 0
        game.board[5][column] = red_circle
      end
      it 'returns 1' do
        column = 0
        expect(game.marks_in_column(column)).to eq(1)
      end
    end
  end

  describe '#set_mark' do
    before do
      allow(player).to receive(:symbol).and_return("\e[31m\u25cf")
    end
    context 'when selected column is empty' do
      it 'changes board on given columns last element to mark' do
        column = 0
        expect{game.set_mark(column, player)}.to change { game.board[5][column] }
      end
    end
    context 'when selected column has elements in it' do
      elements_to_add = rand(5)
      column = 0
      before do
        for i in 0..elements_to_add do
          game.set_mark(column, player)
        end
      end
      it 'changes board on given columns element that is equal to 5 - count of marks' do
        expect{game.set_mark(column, player)}.to change { game.board[5 - elements_to_add - 1][column] }
      end
    end
  end

  describe '#connected_four?' do
    context 'when 4 pieces are in one diagonal' do
      before do
        red_circle = "\e[31m\u25cf"
        game.board[0][0] = red_circle
        game.board[1][1] = red_circle
        game.board[2][2] = red_circle
        game.board[3][3] = red_circle
      end
      it 'returns true' do
        expect(game.connected_four?).to be true
      end
    end
    context 'when 4 pieces are in one row' do
      before do
        red_circle = "\e[31m\u25cf"
        game.board[1][0] = red_circle
        game.board[1][1] = red_circle
        game.board[1][2] = red_circle
        game.board[1][3] = red_circle
      end
      it 'returns true' do
        expect(game.connected_four?).to be true
      end
    end
    context 'when 4 pieces are in one column' do
      before do
        red_circle = "\e[31m\u25cf"
        game.board[0][1] = red_circle
        game.board[1][1] = red_circle
        game.board[2][1] = red_circle
        game.board[3][1] = red_circle
      end
      it 'returns true' do
        expect(game.connected_four?).to be true
      end
    end
    context 'when 4 pieces are not in one column' do
      before do
        red_circle = "\e[31m\u25cf"
        game.board[0][1] = red_circle
        game.board[1][2] = red_circle
        game.board[2][1] = red_circle
        game.board[3][1] = red_circle
      end
      it 'returns false' do
        expect(game.connected_four?).to be false
      end
    end
  end

  describe '#column_full?' do
    context 'when column is full' do
      before do
        game.board[0][0] = "\e[31m\u25cf"
      end
      it 'returns true' do
        expect(game.column_full?(0)).to be true
      end
    end
    context 'when column isnt full' do
      it 'returns false' do
        expect(game.column_full?(0)).to be false
      end
    end
  end
end
