require 'spec_helper'

describe Hydra::Works::AddGenericWorkToGenericWork do

  let(:subject) { Hydra::Works::GenericWork.create }

  describe '#call' do
    context 'with acceptable generic_works' do
      let(:generic_work1) { Hydra::Works::GenericWork.create }
      let(:generic_work2) { Hydra::Works::GenericWork.create }
      let(:generic_work3) { Hydra::Works::GenericWork.create }
      let(:generic_work4) { Hydra::Works::GenericWork.create }
      let(:generic_work5) { Hydra::Works::GenericWork.create }
      let(:generic_file1)   { Hydra::Works::GenericFile.create }
      let(:generic_file2)   { Hydra::Works::GenericFile.create }

      it 'should add generic_work to empty generic work aggregation' do
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject ) ).to eq [generic_work1]
      end

      it 'should add generic_work to generic work aggregation with generic_works' do
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work2 )
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject ) ).to eq [generic_work1,generic_work2]
      end

      it 'should allow generic_works to repeat' do
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work2 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject ) ).to eq [generic_work1,generic_work2,generic_work1]
      end

      context 'with generic_files and generic_works' do
        before do
          Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file1 )
          Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file2 )
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work2 )
          subject.save
        end

        it 'should add generic_work to generic_work with generic_files and generic_works' do
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work3 )
          expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject ) ).to eq [generic_work1,generic_work2,generic_work3]
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr['generic_works_ssim']).to include(generic_work1.id,generic_work2.id,generic_work3.id)
          expect(subject.to_solr['generic_works_ssim']).not_to include(generic_file1.id,generic_file2.id)
          expect(subject.to_solr['generic_files_ssim']).to include(generic_file1.id,generic_file2.id)
          expect(subject.to_solr['generic_files_ssim']).not_to include(generic_work1.id,generic_work2.id,generic_work3.id)
        end
        end
      end

      it 'should aggregate generic_works in a sub-generic_work of a generic_work' do
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        subject.save
        Hydra::Works::AddGenericWorkToGenericWork.call( generic_work1, generic_work2 )
        generic_work1.save
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject ) ).to eq [generic_work1]
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( generic_work1 ) ).to eq [generic_work2]
      end

      describe 'adding generic works that are ancestors' do
        let(:error_message) { "an object can't be an ancestor of itself" }

        context 'when the source generic work is the same' do
          it 'raises an error' do
            expect{ Hydra::Works::AddGenericWorkToGenericWork.call( generic_work1, generic_work1 )}.to raise_error(ArgumentError, error_message)
          end
        end

        before do
          Hydra::Works::AddGenericWorkToGenericWork.call( generic_work1, generic_work2 )
          generic_work1.save
        end

        it 'raises and error' do
          expect{ Hydra::Works::AddGenericWorkToGenericWork.call( generic_work2, generic_work1 )}.to raise_error(ArgumentError, error_message)
        end

        context 'with more ancestors' do
          before do
            Hydra::Works::AddGenericWorkToGenericWork.call( generic_work2, generic_work3 )
            generic_work2.save
          end

          it 'raises an error' do
            expect{ Hydra::Works::AddGenericWorkToGenericWork.call( generic_work3, generic_work1 )}.to raise_error(ArgumentError, error_message)
          end

          context 'with a more complicated example' do
            before do
              Hydra::Works::AddGenericWorkToGenericWork.call( generic_work3, generic_work4 )
              Hydra::Works::AddGenericWorkToGenericWork.call( generic_work3, generic_work5 )
              generic_work3.save
            end

            it 'raises errors' do
              expect{ Hydra::Works::AddGenericWorkToGenericWork.call( generic_work4, generic_work1 )}.to raise_error(ArgumentError, error_message)
              expect{ Hydra::Works::AddGenericWorkToGenericWork.call( generic_work4, generic_work2 )}.to raise_error(ArgumentError, error_message)
            end
          end
        end
      end

      describe 'aggregates generic_works that implement Hydra::Works' do
        before do
          class DummyIncWork < ActiveFedora::Base
            include Hydra::Works::GenericWorkBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncWork) }
        let(:iwork1) { DummyIncWork.create }

        it 'should accept implementing generic_work as a child' do
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, iwork1 )
          subject.save
          expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject ) ).to eq [iwork1]
        end
      end

      describe 'aggregates generic_works that extend Hydra::Works' do
        before do
          class DummyExtWork < Hydra::Works::GenericWork
          end
        end
        after { Object.send(:remove_const, :DummyExtWork) }
        let(:ework1) { DummyExtWork.create }

        it 'should accept extending generic_work as a child' do
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, ework1 )
          subject.save
          expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject ) ).to eq [ework1]
        end
      end
    end


    context 'with unacceptable child generic_works' do
      let(:collection1)      { Hydra::Works::Collection.create }
      let(:generic_file1)    { Hydra::Works::GenericFile.create }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
      let(:pcdm_object1)     { Hydra::PCDM::Object.create }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.create }

      let(:error_message) { 'child_generic_work must be a hydra-works generic work' }

      it 'should NOT aggregate Hydra::Works::Collection in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::Works::GenericFile in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collections in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Objects in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, pcdm_object1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, pcdm_file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with unacceptable parent generic works' do
      let(:collection1)      { Hydra::Works::Collection.create }
      let(:generic_work1)    { Hydra::Works::GenericWork.create }
      let(:generic_work2)    { Hydra::Works::GenericWork.create }
      let(:generic_file1)    { Hydra::Works::GenericFile.create }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
      let(:pcdm_object1)     { Hydra::PCDM::Object.create }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.create }

      let(:error_message) { 'parent_generic_work must be a hydra-works generic work' }

      it 'should NOT accept Hydra::Works::Collection as parent generic work' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( collection1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::Works::GenericFile as parent generic work' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( generic_file1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Collections as parent generic work' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( pcdm_collection1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Objects as parent generic work' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( pcdm_object1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent generic work' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( pcdm_file1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent generic work' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( non_PCDM_object, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent generic work' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( af_base_object, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end
    end

  end

end
