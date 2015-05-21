require 'spec_helper'

describe Hydra::Works::MoveGenericFileToGenericWork do
  # Without this dummy RSpec fails to recognize "RDFVocabularies::PCDMTerms"
  let!(:dummy) { Hydra::PCDM::File }
  let(:workA) { double(type: [RDFVocabularies::PCDMTerms.Object]) }
  let(:workB) { double(type: [RDFVocabularies::PCDMTerms.Object]) }
  let(:file1) { double(type: [RDFVocabularies::PCDMTerms.File]) }
  context "move generic file" do 
    it "moves file from one work to another" do
      expect(Hydra::Works::AddGenericFileToGenericWork).to receive(:call).with(workB, file1)
      expect(Hydra::Works::RemoveGenericFileFromGenericWork).to receive(:call).with(workA, file1)
      Hydra::Works::MoveGenericFileToGenericWork.call(workA, workB, file1)
    end
  end
end