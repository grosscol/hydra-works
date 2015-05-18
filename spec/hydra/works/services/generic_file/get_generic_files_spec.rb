require 'spec_helper'

describe Hydra::Works::GetGenericFilesFromGenericFile do

  subject { Hydra::Works::GenericFile.create }

  let(:generic_file1) { Hydra::Works::GenericFile.create }
  let(:generic_file2) { Hydra::Works::GenericFile.create }

  describe '#call' do
    it 'should return empty array when no members' do
      subject.save
      expect(Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq []
    end

    it 'should return generic_files when generic_files are aggregated' do
      Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file1 )
      Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file2 )
      subject.save
      expect(Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file1,generic_file2]
    end

  end
end
