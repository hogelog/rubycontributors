class Preview::ContributorsController < ApplicationController
  def index
    contributors = Contributor.with_commits_count
      .select("contributors.*, COUNT(commits.id) as commits_count")
      .left_joins(:commits)
      .group(:id)
      .order(commits_count: :desc)

    render "public/contributors/index", locals: { contributors: }
  end

  def show
    contributor = ContributorName.find_by_name!(params[:id]).contributor
    render "public/contributors/show", locals: { contributor: }
  end
end 
