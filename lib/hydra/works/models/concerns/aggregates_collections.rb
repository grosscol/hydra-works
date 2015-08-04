module Hydra::Works
  # Allows instances of a class to aggregate (pcdm:hasMember) hydra-works collections
  module AggregatesCollections

    def child_collection_ids
      child_collections.map(&:id)
    end
  end
end
