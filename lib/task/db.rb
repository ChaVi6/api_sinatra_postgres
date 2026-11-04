require 'rake'
require 'dotenv/tasks'

namespace :db do
  require 'sequel'
  Sequel.extension :migration

  environment = ENV['RACK_ENV'] || 'development'

  ENV['DATABASE'] = 'sinatra_seq_dev' if environment == 'development'
  ENV['DATABASE'] = 'sinatra_seq_test' if environment == 'test'
  ENV['DATABASE'] = 'sinatra_seq_prod' if environment == 'production'

  migrations_directory = 'db/migrations'
  connection_string = "postgres://sinatra_admin:password@localhost/#{ENV['DATABASE']}"

  db = Sequel.connect(connection_string)

  desc "Prints current schema version"
  task :version do
    version = if db.tables.include?(:schema_info)
                db[:schema_info].first[:version]
              end || 0
    puts "Schema Version: #{version}"
  end

  desc 'Run migrations up to specified version or to latest.'
  task :migrate, [:version] => [:dotenv] do |_t, args|
    version = args[:version]
    raise "Missing Connection string" if connection_string.nil?

    message = if version.nil?
                Sequel::Migrator.run(db, migrations_directory)
                'Migrated to latest'
              else
                Sequel::Migrator.run(db, migrations_directory, target: version.to_i)
                "Migrated to version #{version}"
              end
    puts message if environment != 'test'
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, [:target] do |_t, args|
    args.with_defaults(:target => 0)
    Sequel::Migrator.run(db, migrations_directory, :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    Sequel::Migrator.run(db, migrations_directory, :target => 0)
    Sequel::Migrator.run(db, migrations_directory)
    Rake::Task['db:version'].execute
  end

  desc "Load seed data into database"
  task :seed do
    puts 'seed task running'

    require 'sequel'
    Sequel.extension :seed

    Sequel::Seed.setup :development

    DB = Sequel.connect(connection_string)

    Sequel::Seeder.apply(DB, './seeds')
  end
end