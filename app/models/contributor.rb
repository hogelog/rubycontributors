class Contributor < ApplicationRecord
  has_many :commits

  has_many :contributor_logins
  has_many :contributor_names
  has_many :contributor_emails
end 
