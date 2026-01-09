module CommunitiesHelper
  def approval_badge(community)
    if community.auto?
      content_tag(:span, "自動承認", class: "badge bg-primary")
    else
      content_tag(:span, "承認制", class: "badge bg-danger")
    end
  end
end

