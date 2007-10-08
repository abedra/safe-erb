# SafeERB

require 'erb'
require 'action_controller'
require 'action_view'

class ActionController::Base
  # Object#taint is set when the request comes from FastCGI or WEBrick,
  # but it is not set in Mongrel and also functional / integration testing
  # so we'll set it anyways in the filter
  before_filter :taint_request
  
  private
  
  def taint_hash(hash)
    hash.each do |k, v|
      case v
      when String
        v.taint
      when Hash
        taint_hash(v)
      end
    end
  end
  
  def taint_request
    taint_hash(params)
    cookies.each do |k, v|
      v.taint
    end
  end
  
  public
  
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

class String
  def concat_unless_tainted(str)
    raise "attempted to output tainted string: #{str}" if str.is_a?(String) && str.tainted?
    concat(str)
  end
end

class ERB
  cattr_accessor :check_tainted
  alias_method :original_set_eoutvar, :set_eoutvar
  
  def self.with_checking_tainted(&block)
    # not thread safe
    ERB.check_tainted = true
    begin
      yield
    ensure
      ERB.check_tainted = false
    end
  end
  
  def set_eoutvar(compiler, eoutvar = '_erbout')
    original_set_eoutvar(compiler, eoutvar)
    if check_tainted
      if compiler.respond_to?(:insert_cmd)
        compiler.insert_cmd = "#{eoutvar}.concat_unless_tainted"
      else
        compiler.put_cmd = "#{eoutvar}.concat_unless_tainted"
      end
    end
  end
  
  module Util
    alias_method :html_escape_without_untaint, :html_escape
    
    def html_escape(s)
      h = html_escape_without_untaint(s)
      h.untaint
      h
    end
    
    alias_method :h, :html_escape
    
    module_function :h
    module_function :html_escape
    module_function :html_escape_without_untaint
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
