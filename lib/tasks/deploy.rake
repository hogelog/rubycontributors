namespace :deploy do
  desc "Import commits"
  task :import do
    sh "bundle exec rails runner CommitImportJob.perform_now"
  end

  desc "Deploy to pages"
  task :pages do
    sh "bundle exec rails runner SiteGenerateJob.perform_now"
    sh "npm run deploy"
  end
end
