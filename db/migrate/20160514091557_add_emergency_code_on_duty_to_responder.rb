class AddEmergencyCodeOnDutyToResponder < ActiveRecord::Migration
  def change
    add_column :responders, :emergency_code, :string
    add_column :responders, :on_duty, :boolean, default: false
  end
end
