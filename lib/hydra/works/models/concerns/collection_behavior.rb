module Hydra::Works
  module CollectionBehavior
    extend ActiveSupport::Concern
    include Hydra::PCDM::CollectionBehavior 


    # TODO: Extend rdf type to include RDFVocabularies::WorksTerms.Collection  (see issue #71)
    included do
      type [RDFVocabularies::PCDMTerms.Collection,WorksVocabularies::WorksTerms.Collection]
    end

    # behavior:
    #   1) Hydra::Works::Collection can aggregate Hydra::Works::Collection
    #   2) Hydra::Works::Collection can aggregate Hydra::Works::GenericWork

    #   3) Hydra::Works::Collection can NOT aggregate Hydra::PCDM::Collection unless it is also a Hydra::Works::Collection
    #   4) Hydra::Works::Collection can NOT aggregate Hydra::Works::GenericFile
    #   5) Hydra::Works::Collection can NOT aggregate non-PCDM object
    #   6) Hydra::Works::Collection can NOT contain Hydra::PCDM::File
    #   7) Hydra::Works::Collection can NOT contain

    #   8) Hydra::Works::Collection can have descriptive metadata
    #   9) Hydra::Works::Collection can have access metadata

    def collections= collections
      raise ArgumentError, "each collection must be a hydra works collection" unless collections.all? { |c| Hydra::Works.collection? c }
      raise ArgumentError, "a collection can't be an ancestor of itself" if collection_ancestor?(collections)
      self.members = self.generic_works + collections
    end

    def collections
      members.to_a.select { |m| Hydra::Works.collection? m }
    end

    def generic_works= generic_works
      raise ArgumentError, "each generic_work must be a hydra works generic work" unless generic_works.all? { |w| Hydra::Works.generic_work? w }
      self.members = self.collections + generic_works
    end

    def generic_works
      members.to_a.select { |m| Hydra::Works.generic_work? m }
    end

  end
end
