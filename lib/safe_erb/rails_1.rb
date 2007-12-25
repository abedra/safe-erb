# Rails 1.x dependent code (tested on 1.2.6)

class ActionController::Base
  alias_method :render_template_without_checking_tainted, :render_template
  
  def render_template(template, status = nil, type = :rhtml, local_assigns = {})
    if @skip_checking_tainted
      render_template_without_checking_tainted(template, status, type, local_assigns)
    else
      ERB.with_checking_tainted do
        render_template_without_checking_tainted(template, status, type, local_assigns)
      end
    end
  end
  
  alias_method :render_file_without_checking_tainted, :render_file
  
  def render_file(template_path, status = nil, use_full_path = false, locals = {})
    if @skip_checking_tainted
      render_file_without_checking_tainted(template_path, status, use_full_path, locals)
    else
      ERB.with_checking_tainted do
        render_file_without_checking_tainted(template_path, status, use_full_path, locals)
      end
    end
  end
end

module ActionView::Helpers::TextHelper
  alias_method :strip_tags_without_untaint, :strip_tags
  
  def strip_tags(html)
    str = strip_tags_without_untaint(html)
    str.untaint
    str
  end
end
