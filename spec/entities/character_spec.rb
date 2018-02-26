require "spec_helper"
require './entities/character.rb'

shared_examples 'a valid record' do
  it { expect(character).to be_a(described_class) }
  it { expect(character).not_to be_nil }
  it { expect(character.id).not_to be_nil }
  it { expect(character.name).to eq(name) }
  it { expect(character.description).not_to be_nil }
  it { expect(character.thumbnail).not_to be_nil }
  it { expect(character.resource_uri).not_to be_nil }
end

RSpec.describe Character, type: :model do
  let(:character) { single_caracter }
  let(:character) { Character.new() }

  it { expect(character).to respond_to(:id, :name, :description, :resource_uri, :thumbnail, :stories) }

  it 'is valid with valid attributes' do
    expect(character).to be_an_instance_of(Character)
  end

  describe '.all' do
    before do
      expect_any_instance_of(MarvelApiService).
        to receive(:call).
          and_return(characters_api_response)
    end

    subject(:all) { described_class.all }
    subject(:character) { all[0] }
    let(:name) { character.name }

    it { expect(all).to be_a(Array) }
    it { expect(all).not_to be_empty }

    it_behaves_like 'a valid record'
  end

  describe '.find_by_name' do
    let(:name) { 'Hulk' }

    before do
      expect_any_instance_of(MarvelApiService).
        to receive(:call).
          with(path: "#{described_class.name.downcase}s", name: name).
            and_return(single_character_api_response)
    end

    subject(:find_by_name) { described_class.find_by_name(name) }
    subject(:character) { described_class.find_by_name(name).first }

    it { expect(find_by_name).to be_a(Array) }
    it { expect(find_by_name).not_to be_empty }

    it_behaves_like 'a valid record'
  end
end
