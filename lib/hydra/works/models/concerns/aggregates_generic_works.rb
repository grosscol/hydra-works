module Hydra::Works
  # Allows instances of a class to aggregate (pcdm:hasMember) hydra-works generic works
  module AggregatesGenericWorks

    def child_generic_work_ids
      child_generic_works.map(&:id)
    end
  end
end
