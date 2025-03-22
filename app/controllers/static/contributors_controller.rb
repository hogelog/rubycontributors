class Static::ContributorsController < ApplicationController
  def index
    contributors = Contributor
      .select("contributors.*, COUNT(commits.id) as commits_count")
      .left_joins(:commits)
      .group(:id)
      .order(commits_count: :desc)
      .preload(:contributor_names, :contributor_emails, :contributor_logins, :commits)
      .reject {|contributor| contributor.bot? }

    render "static/contributors/index", locals: { contributors: }
  end

  def show
    contributor = ContributorName.find_by_name!(params[:id]).contributor
    render "static/contributors/show", locals: { contributor: }
  end
end 
