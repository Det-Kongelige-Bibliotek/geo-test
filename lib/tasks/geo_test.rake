require 'rails/generators'
require 'generators/geoblacklight/install_generator'

namespace :geotest do
  desc 'start solr'
  task :server, [:rails_server_args] do |_t, args|
    require 'solr_wrapper'
    SolrWrapper.wrap(port: '8983') do |solr|
      solr.with_collection(name: 'blacklight-core', dir: File.join(File.expand_path('../../', File.dirname(__FILE__)), 'solr', 'conf')) do
        puts "\nSolr server running: http://localhost:#{solr.port}/solr/#/blacklight-core"
        puts "\n^C to stop"
        puts ' '
      end
    end
  end

  desc 'import KB data'
  task :kb_ingest  => :environment do
    docs = Dir['spec/fixtures/solr_documents/kb-documents.json'].map { |f| JSON.parse File.read(f) }.flatten
    Blacklight.default_index.connection.add docs
    Blacklight.default_index.connection.commit
  end
end
