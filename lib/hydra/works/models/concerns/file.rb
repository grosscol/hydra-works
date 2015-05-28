module Hydra::Works
  # Namespace for Modules with functionality specific to Files
  module File

    extend ActiveSupport::Concern

    autoload :Derivatives,            'hydra/works/models/concerns/file/derivatives'
    autoload :MimeTypes,              'hydra/works/models/concerns/file/mime_types'
    autoload :ContainedFiles,         'hydra/works/models/concerns/file/contained_files'

  end
end