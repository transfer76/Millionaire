require 'rails_helper'
require 'support/my_spec_helper'

RSpec.describe Game, type: :model do

  let(:user) { FactoryGirl.create(:user) }
  let(:game_w_questions) { FactoryGirl.create(:game_with_questions, user: user) }

  context 'Game Factory' do
    it 'Game.create_game! new correct game' do
      generate_questions(60)
      
      game = nil
      expect {
        game = Game.create_game_for_user!(user)
      }.to change(Game, :count).by(1).and(
        change(GameQuestion, :count).by(15).and(
            change(Question, :count).by(0)
        )
      )

      expect(game.user).to eq(user)
      expect(game.status).to eq(:in_progress)
      expect(game.game_questions.size).to eq(15)
      expect(game.game_questions.map(&:level)).to eq (0..14).to_a
    end
  end

  context 'game mechanics' do
    it 'answer correct continues game' do
      level = game_w_questions.current_level
      q = game_w_questions.current_game_question
      expect(game_w_questions.status).to eq(:in_progress)

      game_w_questions.answer_current_question!(q.correct_answer_key)

      expect(game_w_questions.current_level).to eq(level + 1)

      expect(game_w_questions.current_game_question).not_to eq q

      expect(game_w_questions.status).to eq(:in_progress)
      expect(game_w_questions.finished?).to be_falsey
    end

    it 'take_money! finishes the game' do
      q = game_w_questions.current_game_question
      game_w_questions.answer_current_question!(q.correct_answer_key)

      game_w_questions.take_money!

      prize = game_w_questions.prize
      expect(prize).to be > 0
      expect(game_w_questions.status).to eq :money
      expect(game_w_questions).to be_finished
      expect(user.balance).to eq prize
    end
  end

  context '.status' do
    before(:each) do
      game_w_questions.finished_at = Time.now
      expect(game_w_questions).to be_finished
    end

    it ':won' do
      game_w_questions.current_level = Question::QUESTION_LEVELS.max + 1
      expect(game_w_questions.status).to eq(:won)
    end

    it ':fail' do
      game_w_questions.is_failed = true
      expect(game_w_questions.status).to eq(:fail)
    end

    it ':timeout' do
      game_w_questions.created_at = 1.hour.ago
      game_w_questions.is_failed = true
      expect(game_w_questions.status).to eq(:timeout)
    end

    it ':money' do
      expect(game_w_questions.status).to eq(:money)
    end
  end

  context 'current_game_level' do
    it 'returns correct current game question' do
      expect(game_w_questions.current_game_question).to eq(game_w_questions.game_questions.first)
    end
  end

  context 'previous_level' do
    it 'returns previuos game level' do
      expect(game_w_questions.previous_level).to eq -1
    end
  end

  context 'answer_current_question!' do
    let(:q) { game_w_questions.current_game_question }
    let(:incorrect_answer) { %w(a b c d).reject { |a| a == q.correct_answer_key }.sample }

    it 'answer is correct' do
      expect(game_w_questions.status).to eq(:in_progress)
      expect(game_w_questions).not_to be_finished
      expect { game_w_questions.answer_current_question!(q.correct_answer_key) }.to change(game_w_questions, :current_level).by(1)
      expect(game_w_questions.answer_current_question!(q.correct_answer_key)).to be_truthy
    end

    it 'answer is incorrect' do
      expect(game_w_questions.answer_current_question!(incorrect_answer)).to be_falsey
      expect { game_w_questions.answer_current_question!(incorrect_answer) }.not_to change(game_w_questions, :current_level)
      expect(game_w_questions.status).to eq(:fail)
      expect(game_w_questions).to be_finished
    end

    it 'answer is last' do
      game_w_questions.current_level = Question::QUESTION_LEVELS.max
      game_w_questions.answer_current_question!(q.correct_answer_key)

      expect(game_w_questions).to be_finished
      expect(game_w_questions.prize).to eq Game::PRIZES.last
      expect(game_w_questions.status).to eq(:won)
    end

    it 'time is out' do
      game_w_questions.created_at = 1.hour.ago

      expect { game_w_questions.answer_current_question!(q.correct_answer_key) }.not_to change(game_w_questions, :current_level)
      expect(game_w_questions.status).to eq(:timeout)
      expect(game_w_questions).to be_finished
    end
  end
end
