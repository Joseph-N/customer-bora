module ApplicationHelper
  include Twitter::Autolink

  def errors_for(resource)
    if resource.errors.any?
      messages = resource.errors.full_messages.map { |msg| content_tag(:p, msg) }.join
      html = <<-HTML
      <div class="alert alert-danger alert-dismissable">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
        <strong>Ooops!</strong>
        #{messages}
      </div>
      HTML
      html.html_safe
    end
  end
end
