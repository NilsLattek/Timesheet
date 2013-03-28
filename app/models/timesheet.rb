class Timesheet < ActiveRecord::Base
  attr_accessible :date, :end_time, :lunch_break, :start_time, :entries_attributes

  belongs_to :user
  has_many :entries, :dependent => :destroy
  accepts_nested_attributes_for :entries, :allow_destroy => true

  validates :date, :start_time, :end_time, :lunch_break, :presence => true
  validates_associated :entries

  validate :validate_times, :validate_entries

  def validate_times
    if start_time && end_time
      errors.add("endTime", "cannot be before start time") if end_time < start_time
    end
  end

  def validate_entries
    hours = self.hours_worked

    if hours >= 0
      errors.add("entries", "should be provided for the whole day") if entries.empty?

      # check if hours_worked equals the sum from all entry hours
      entry_hours = self.entries.reduce(0) { |sum, entry|
        #return 0 if not entry.hours
        return sum if not entry.hours

        sum + entry.hours
      }
      errors.add("entries", "cannot exceed working hours") if entry_hours > hours
    else
      errors.add("hours_worked", "you have not worked a minute")
    end
  end

  def hours_worked
    if !start_time || !end_time || !lunch_break
      return 0
    end

    diff_minutes = (end_time - start_time) / 60
    diff_minutes -= lunch_break
    (diff_minutes / 60).round 2
  end
end
