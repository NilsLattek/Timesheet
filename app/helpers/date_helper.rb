module DateHelper
  def thursday_of_week(date)
    date + (4 - date.cwday)
  end

  def cweeks_in_month(month)
    weeks = []

    iterator = month.beginning_of_month
    while iterator < month.end_of_month
      weeks << self.thursday_of_week(iterator)
      iterator = iterator.next_week
    end

    weeks
  end
end
