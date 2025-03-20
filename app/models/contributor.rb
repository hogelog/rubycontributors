require "github"

class Contributor < ApplicationRecord
  has_many :commits

  has_many :contributor_logins
  has_many :contributor_names
  has_many :contributor_emails

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
end 
