# Rails 2.0 dependent code (tested on 2.0.2)

class ActionController::Base
  def render_with_checking_tainted(*args, &blk)
    if @skip_checking_tainted
      render_without_checking_tainted(*args, &blk)
    else
      ERB.with_checking_tainted do
        render_without_checking_tainted(*args, &blk)
      end
    end
  end

  alias_method_chain :render, :checking_tainted
end

module ActionView::Helpers::SanitizeHelper
  def strip_tags_with_untaint(html)
    str = strip_tags_without_untaint(html)
    str.untaint
    str
  end

  alias_method_chain :strip_tags, :untaint
end
