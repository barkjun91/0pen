require 'maruku' # $gem install maruku
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def markdown(text)
    text.blank? ? "" : Maruku.new(text).to_html
  end
end
