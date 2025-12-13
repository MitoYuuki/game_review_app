module ApplicationHelper
  def flash_class(key)
    case key.to_sym
    when :notice then "success"
    when :alert  then "danger"
    else "info"
    end
  end
end
