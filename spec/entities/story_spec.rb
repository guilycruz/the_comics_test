require "spec_helper"
require './entities/character.rb'

RSpec.describe Story, type: :model do
  let(:story) { Story.new() }

  it { expect(story).to respond_to(:id, :name, :description, :resource_uri, :thumbnail, :characters) }

  it 'is valid with valid attributes' do
    expect(story).to be_an_instance_of(Story)
  end

  # describe '.find_by_id' do
  #   let(:id) { '19947' }
  #
  #   before do
  #     expect_any_instance_of(MarvelApiService).
  #       to receive(:call).
  #           and_return(single_story_api_response)
  #   end
  #
  #   subject(:find_by_id) { described_class.find_by_id(id) }
  #   # subject(:character) { described_class.find_by_name(name).first }
  #
  #   it { expect(find_by_id).to be_a(Array) }
  #   it { expect(find_by_id.size).to eq(1) }
  #
  #   # it_behaves_like 'a valid record'
  # end

  describe '#characters' do
    let(:id) { '1018' }

    before do
      story.id = id
      expect_any_instance_of(MarvelApiService).
        to receive(:call).
          with(path: "#{described_class.plural}/#{id}/characters", limit: described_class::CHARACTERS_LIMIT).
            and_return(story_characters_api_response)
    end

    subject(:characters) { story.characters }

    it { expect(characters).to be_a(Array) }
    it { expect(characters).not_to be_empty }
    it { expect(characters[0]).to be_a(Character) }
  end
end
