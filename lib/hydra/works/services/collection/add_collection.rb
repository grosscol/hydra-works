module Hydra::Works
  class AddCollectionToCollection

    ##
    # Add a collection to a collection.
    #
    # @param [Hydra::Works::Collection] :parent_collection to which to add collection
    # @param [Hydra::Works::Collection] :child_collection being added
    #
    # @return [Hydra::Works::Collection] the updated hydra works collection

    def self.call( parent_collection, child_collection )
      raise ArgumentError, 'parent_collection must be a hydra-works collection' unless Hydra::Works.collection? parent_collection
      raise ArgumentError, 'child_collection must be a hydra-works collection' unless Hydra::Works.collection? child_collection
      Hydra::PCDM::AddCollectionToCollection.call( parent_collection, child_collection )
    end

  end
end
