class ContributorsController < ApplicationController
  before_action :set_contributor, only: [:show]

  def index
    @contributors = Contributor.all.preload(:contributor_names, :contributor_emails, :contributor_logins).order(:id)
  end

  def show
    @similar_contributors = @contributor.similar_contributors
  end

  private

  def set_contributor
    @contributor = Contributor.find(params[:id])
  end

  def contributor_params
    params.require(:contributor).permit!
  end
end 
