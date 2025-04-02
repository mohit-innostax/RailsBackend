class TodoAppPolicy < ApplicationPolicy
  def destroy?
    user.id.in?([ 3, 4 ])  # Allow only users with ID 3 or 4 to delete
  end
end
