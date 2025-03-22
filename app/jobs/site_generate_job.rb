require "fileutils"

class SiteGenerateJob < ApplicationJob
  def perform
    FileUtils.rm_rf("tmp/public")
    FileUtils.cp_r("public/", "tmp/public/")

    about_html = Static::AboutsController.renderer.render_to_string(
      template: "static/abouts/show",
      locals: {}
    )
    File.write("tmp/public/about.html", about_html)

    contributors = Contributor
      .select("contributors.*, COUNT(commits.id) as commits_count")
      .left_joins(:commits)
      .group(:id)
      .order(commits_count: :desc)
      .preload(:contributor_names, :contributor_emails, :contributor_logins, :commits)
      .reject {|contributor| contributor.bot? }

    index_html = Static::ContributorsController.renderer.render_to_string(
      template: "static/contributors/index",
      locals: { contributors: }
    )
    File.write("tmp/public/index.html", index_html)

    FileUtils.mkdir("tmp/public/contributors")
    contributors.each do |contributor|
      show_html = Static::ContributorsController.renderer.render_to_string(
        template: "static/contributors/show",
        locals: { contributor: }
      )
      html_path = "tmp/public/contributors/#{contributor.name_path}.html"
      if File.exist?(html_path)
        STDERR.puts "File already exists: #{html_path}"
      else
        File.write(html_path, show_html)
      end
    end
  end
end
