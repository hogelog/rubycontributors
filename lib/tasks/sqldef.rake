namespace :sqldef do
  def config
    Rails.configuration.database_configuration[Rails.env]
  end

  desc "Export the database schema"
  task :export do
    sh "sqlite3def --export #{config["database"]} > db/schema.sql"
  end

  desc "Dry run the schema"
  task :dry_run do
    sh "sqlite3def --dry-run #{config["database"]} < db/schema.sql"
  end

  desc "Apply the schema"
  task :apply do
    sh "sqlite3def #{config["database"]} < db/schema.sql"
  end

  desc "Force apply the schema"
  task :force_apply do
    sh "sqlite3def --enable-drop-table #{config["database"]} < db/schema.sql"
  end
end
