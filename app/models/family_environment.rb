class FamilyEnvironment < ApplicationRecord
  belongs_to :student
  # has_many :student_family_environments
  # has_many :student_family_environment_students, through: :student_family_environments, source: :student
end
