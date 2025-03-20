class ContributorsController < ApplicationController
  before_action :set_contributor, only: [:show, :update]

  def index
    @contributors = Contributor.all.preload(:contributor_names, :contributor_emails, :contributor_logins).order(:id)
  end

  def show
    @similar_contributors = @contributor.similar_contributors
  end

  def update
    if params[:target_id].present?
      target_contributor = Contributor.find(params[:target_id])
      @contributor.merge!(target_contributor)
      redirect_to @contributor, notice: 'Contributors were successfully merged.'
    else
      redirect_to @contributor, alert: 'Invalid update request.'
    end
  end

  private

  def set_contributor
    @contributor = Contributor.find(params[:id])
  end

  def contributor_params
    params.require(:contributor).permit!
  end
end 
