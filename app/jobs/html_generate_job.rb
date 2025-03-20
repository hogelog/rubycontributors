require "fileutils"

class HtmlGenerateJob < ApplicationJob
  def perform
    contributors = Contributor
      .select("contributors.*, COUNT(commits.id) as commits_count")
      .left_joins(:commits)
      .group(:id)
      .order(commits_count: :desc)

    index_html = ApplicationController.renderer.render_to_string(
      template: "public/contributors/index",
      locals: { contributors: }
    )
    File.write("tmp/public/index.html", index_html)

    FileUtils.rm(Dir.glob("tmp/public/contributors/*.html"))
    contributors.each do |contributor|
      show_html = ApplicationController.renderer.render_to_string(
        template: "public/contributors/show",
        locals: { contributor: }
      )
      html_path = "tmp/public/contributors/#{contributor.name_path}.html"
      File.write(html_path, show_html)
    end
  end
end
