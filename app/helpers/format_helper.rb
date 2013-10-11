module FormatHelper
  def format_hours(hours)
    number_with_precision(hours, :strip_insignificant_zeros => true).to_s + 'h'
  end
end
