class CommitImportJob < ApplicationJob
  RUBY_REPO_DIR = ENV.fetch("RUBY_REPO_DIR", "../ruby")

  def perform
    commit_logs = []
    revision_range = Commit.last&.sha ? "#{Commit.last.sha}..HEAD" : "HEAD"
    Dir.chdir(RUBY_REPO_DIR) do
      system("git fetch", exception: true)
      IO.popen(%[git log #{revision_range} --pretty=format:"%H\t%at\t%an\t%ae\t%s"], exception: true) do |io|
        io.each_line do |line|
          commit_logs << line.chomp.split("\t")
        end
      end
    end

    commit_logs.reverse_each do |sha, timestamp, name, email, message|
      next if Commit.exists?(sha:)

      time = Time.at(timestamp.to_i)
      contributor = Contributor.find_or_upsert_by_commit!(sha:, name:, email:)
      unless contributor.commits.exists?(sha:)
        Commit.create!(sha:, time:, name:, email:, message:, contributor_id: contributor.id)
      end
    end
  end
end
