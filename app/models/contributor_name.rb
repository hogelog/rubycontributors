class ContributorName < ApplicationRecord
  belongs_to :contributor

  def self.find_by_name!(name)
    candidates = [name, name.gsub("-", " "), name.titleize]
    find_by!(name: candidates)
  end
end 
