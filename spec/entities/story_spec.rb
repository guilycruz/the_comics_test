require "spec_helper"
require './entities/character.rb'

RSpec.describe Story, type: :model do
  let(:story) { Story.new() }

  it { expect(story).to respond_to(:id, :name, :description, :resource_uri, :thumbnail, :characters) }

  it 'is valid with valid attributes' do
    expect(story).to be_an_instance_of(Story)
  end

  # describe '.all' do
  #   before do
  #     expect_any_instance_of(MarvelApiService).
  #       to receive(:call).
  #         and_return(characters_api_response)
  #   end
  #
  #   subject(:all) { described_class.all }
  #   subject(:character) { all[0] }
  #   let(:name) { character.name }
  #
  #   it { expect(all).to be_a(Array) }
  #   it { expect(all).not_to be_empty }
  #
  #   it_behaves_like 'a valid record'
  # end

  describe '#get_details' do
    let(:id) { '19947' }
    before do
      story.id = id
      expect_any_instance_of(MarvelApiService).
        to receive(:call).
            and_return(single_story_api_response)
    end
    subject(:get_details) { story.get_details }

    it 'updates the story values' do
      get_details
      expect(story.description).not_to be_nil
      expect(story.thumbnail).not_to be_nil
      expect(story.characters).not_to be_empty
    end
  end

  describe '.from_json' do

    it 'creates objects for each story item on json' do
      expect(described_class.from_json(single_character_stories_api_response).size).to eq(20)
      expect(described_class.from_json(single_character_stories_api_response)[0]).to be_a(Story)
      expect(described_class.from_json(single_character_stories_api_response)[0].id).not_to be_nil
    end

  end

  describe '.find_by_id' do
    let(:id) { '19947' }

    before do
      expect_any_instance_of(MarvelApiService).
        to receive(:call).
            and_return(single_story_api_response)
    end

    subject(:find_by_id) { described_class.find_by_id(id) }
    # subject(:character) { described_class.find_by_name(name).first }

    it { expect(find_by_id).to be_a(Array) }
    it { expect(find_by_id.size).to eq(1) }

    # it_behaves_like 'a valid record'
  end
end
