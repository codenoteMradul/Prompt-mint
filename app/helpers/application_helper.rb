module ApplicationHelper
  COMMON_COUNTRIES = [
    "United States",
    "Canada",
    "United Kingdom",
    "Australia",
    "New Zealand",
    "India",
    "Singapore",
    "United Arab Emirates",
    "Germany",
    "France",
    "Netherlands",
    "Sweden",
    "Switzerland",
    "Spain",
    "Italy",
    "Brazil",
    "Mexico",
    "South Africa",
    "Nigeria",
    "Japan",
    "South Korea"
  ].freeze

  def country_options_for_select
    COMMON_COUNTRIES.map { |c| [c, c] }
  end
end
