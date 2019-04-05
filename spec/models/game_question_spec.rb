require 'rails_helper'

RSpec.describe GameQuestion, type: :model do

  let(:game_question) { FactoryGirl.create(:game_question, a: 2, b: 1, c: 4, d: 3) }

  context 'game status' do

    it 'correct .variants' do
      expect(game_question.variants).to eq('a' => game_question.question.answer2,
                                           'b' => game_question.question.answer1,
                                           'c' => game_question.question.answer4,
                                           'd' => game_question.question.answer3
      )
    end

    it 'correct .answer_correct?' do
      expect(game_question.answer_correct?('b')).to be_truthy
    end

    it 'correct .help_hash' do
      expect(game_question.help_hash).to eq({})

      game_question.help_hash[:some_key1] = 'blabla1'
      game_question.help_hash['some_key2'] = 'blabla2'

      expect(game_question.save).to be_truthy

      gq = GameQuestion.find(game_question.id)

      expect(gq.help_hash).to eq({some_key1: 'blabla1', 'some_key2' => 'blabla2'})
    end

    it 'correct .level & .text delegates' do
      expect(game_question.text).to eq(game_question.question.text)
      expect(game_question.level).to eq(game_question.question.level)
    end

    it 'correct. correct_answer_key' do
      expect(game_question.correct_answer_key).to eq('b')
    end
  end
 
  context 'user helpers' do
    it 'correct fifty_fifty' do
      expect(game_question.help_hash).not_to include(:fifty_fifty)
      game_question.add_fifty_fifty

      expect(game_question.help_hash).to include(:fifty_fifty)

      ff = game_question.help_hash[:fifty_fifty]
      expect(ff).to include('b')
      expect(ff.size).to eq 2
    end

    it 'correct friend call' do
      expect(game_question.help_hash).not_to include(:friend_call)

      game_question.add_friend_call
      expect(game_question.help_hash).to include(:friend_call)
      expect(game_question.help_hash[:friend_call]).to be

      fc = game_question.help_hash[:friend_call]
      expect(fc).to include('считает, что это вариант')
    end

    it 'correct audience_help' do
      expect(game_question.help_hash).not_to include(:audience_help)

      game_question.add_audience_help

      expect(game_question.help_hash).to include(:audience_help)

      ah = game_question.help_hash[:audience_help]
      expect(ah.keys).to contain_exactly('a', 'b', 'c', 'd')
    end
  end
end
