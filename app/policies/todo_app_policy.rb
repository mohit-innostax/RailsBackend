class TodoAppPolicy < ApplicationPolicy
  def destroy?
    puts "#{user.id}-----------------------"
    user.id.in?([ 3, 4, 7 ])  # Allow only users with ID 3 or 4 to delete
  end
  def update?
    user.id.in?([ 3, 4, 7 ])  # Allow only users with ID 3 or 4 or 7 to delete
  end
end
