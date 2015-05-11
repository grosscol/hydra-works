require 'spec_helper'

describe Hydra::Works::Collection do

  describe "#save" do
    it 'is a Hydra::PCDM::Collection' do
      col = Hydra::Works::Collection.create
      expect(col.save).to be true
      expect(col.resource.type.include? RDFVocabularies::PCDMTerms.Collection).to be true
    end
  end

  describe '#generic_works=' do
    it 'aggregates Hydra::Works::GenericWork in generic_works aggregation' do
      col = Hydra::Works::Collection.create
      work1 = Hydra::Works::GenericWork.create
      work2 = Hydra::Works::GenericWork.create
      col.generic_works = [work1, work2]
      expect(col.save).to be true
    end

    it 'should not aggregate a Hydra::Works::Collection in generic_works aggregation' do
      col = Hydra::Works::Collection.create
      col1 = Hydra::Works::Collection.create
      work1 = Hydra::Works::GenericWork.create
      expect{ col.generic_works = [col1, work1] }.to raise_error(ArgumentError,"each object must be a Hydra::Works::GenericWork")
    end

    it 'should not aggregate a Hydra::Works::GenericFile in generic_works aggregation' do
      col = Hydra::Works::Collection.create
      genfile = Hydra::Works::GenericFile.create
      work = Hydra::Works::GenericWork.create
      expect{ col.generic_works = [ genfile, work ]}.to raise_error(ArgumentError,"each object must be a Hydra::Works::GenericWork")
    end
  end

  describe '#collections=' do
    it 'it can aggregate a Hydra::Works::Collection in collections aggregation' do
      col = Hydra::Works::Collection.create
      col1 = Hydra::Works::Collection.create
      col.collections = [col1]
      expect(col.save).to be true
    end

    it 'should not aggregate a Hydra::PCDM::Collection in the collections aggregation' do
      col = Hydra::Works::Collection.create
      col1 = Hydra::PCDM::Collection.create
      expect{ col.collections = [col1] }.to raise_error(ArgumentError,"each collection must be a Hydra::Works::Collection")
    end
  end

end