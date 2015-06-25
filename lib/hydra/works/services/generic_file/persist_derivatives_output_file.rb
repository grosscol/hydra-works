require 'hydra/derivatives'

module Hydra::Works
  class PersistDerivativesOutputFile < Hydra::Derivatives::PersistOutputFileService

    # Persists a Derivative to a GenericFile
    # @param [Hydra::Works::GenericFile::Base] object the file will be added to
    # @param [File] file the dervivative filestream
    # @param [String] destination_name path to the file
    # @option opts [RDF::URI or String] type URI for the RDF.type that identifies the file's role within the generic_file
    # @option opts [Boolean] update_existing when set to false, always adds a new file.  When set to true, performs a create_or_update
    # @option opts [Boolean] versioning whether to create new version entries (only applicable if +type+ corresponds to a versionable file)

    def self.call(object, file, destination_name, opts={})
      type = opts[:type] || ::RDF::URI("http://pcdm.org/ServiceFile")
      update_existing = opts[:update_existing] || true
      versioning = opts[:versioning] || true
      Hydra::Works::AddFileToGenericFile.call(object, destination_name, type, update_existing: update_existing, versioning: versioning)
    end

  end
end
