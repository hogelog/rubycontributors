require "github"

class Contributor < ApplicationRecord
  SVN_SUFFIX = "@b2dd03c8-39d4-4d8f-98ff-823fe69b080e"

  has_many :commits

  has_many :contributor_logins, dependent: :destroy
  has_many :contributor_names, dependent: :destroy
  has_many :contributor_emails, dependent: :destroy

  def self.find_or_upsert_by_commit!(sha:, name:, email:)
    contributor_email = ContributorEmail.find_by(email:)
   
    # if known email
    if contributor_email
      # Found existing contributor by email
      contributor = contributor_email.contributor
      # Add new name if not exists
      contributor.contributor_names.find_or_create_by!(name:)
      return contributor
    end

    # Fetch GitHub login information
    login = Github.fetch_login(sha, name)

    if login
      # Search for existing contributor by login
      contributor_login = ContributorLogin.find_by(login:)
      if contributor_login
        contributor = contributor_login.contributor
      else
        # Create new contributor with login
        contributor = create!
        contributor.contributor_logins.create!(login:)
      end
    else
      # Create new contributor without login
      contributor = create!
    end

    # Add email and name
    contributor.contributor_emails.create!(email:)
    contributor.contributor_names.find_or_create_by!(name:)
    contributor
  end

  def bot?
    return true if emails.include?("(no author)@b2dd03c8-39d4-4d8f-98ff-823fe69b080e")
    return true if logins.include?("matzbot")
    return true if emails.include?("license.update@rubygems.org")
    return true if emails.include?("test@ruby-lang.org")
    false
  end

  def emails
    @emails ||= contributor_emails.map(&:email)
  end

  def names
    @names ||= contributor_names.map(&:name)
  end

  def logins
    @logins ||= contributor_logins.map(&:login)
  end

  def latest_name
    commits.last&.name
  end

  def name_path
    @name_path ||= URI.encode_uri_component(latest_name.downcase.gsub(" ", "-"))
  end

  def similar_contributors
    candidates = []

    candidates += similar_by_email_local_part unless emails.empty?
    candidates += similar_by_name unless names.empty?

    candidates.uniq
  end

  def merge!(other)
    transaction do
      other.contributor_emails.each do |email|
        contributor_emails.create!(email: email.email)
      end

      other.contributor_names.each do |name|
        contributor_names.create!(name: name.name) unless names.include?(name.name)
      end

      other.contributor_logins.each do |login|
        contributor_logins.create!(login: login.login)
      end

      other.commits.each do |commit|
        commit.update!(contributor: self)
      end

      @emails = nil
      @names = nil
      @logins = nil
      @name_path = nil

      other.destroy!
    end
  end

  private

  def similar_by_email_local_part
    return [] if emails.empty?

    candidates = []
    email_local_parts = emails.map { |email| email.split('@').first }
    email_local_parts.map do |local|
      candidates += self.class.joins(:contributor_emails)
        .where.not(id: id)
        .where("contributor_emails.email LIKE ?", "#{local}@%")
        .distinct
        .to_a
    end

    candidates
  end

  def similar_by_name
    return [] if names.empty?

    self.class.joins(:contributor_names)
      .where.not(id: id)
      .where(contributor_names: { name: names })
      .distinct
  end
end 
