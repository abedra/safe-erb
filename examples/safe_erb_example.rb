require File.expand_path(File.join(File.dirname(__FILE__), "example_helper.rb"))

describe "Safe ERB" do
  
  describe "render_with_checking_tainted" do
    it "test checking" do
      ERB.with_checking_tainted do
        src = ERB.new("<%= File.open('#{__FILE__}'){|f| f.read} %>", nil, '-').src
        lambda { eval(src) }.should raise_error(RuntimeError)
      end
    end
  
    it "test checking non tainted" do
      ERB.with_checking_tainted do
        src = ERB.new("<%= 'This string is not tainted' %>", nil, '-').src
        lambda { eval(src) }.should_not raise_error
      end
    end
  end
  
  describe "Tag Helper Tests" do
    include ActionView::Helpers::TagHelper
    
    it "test taghelper untaints" do
      evil_str = "evil knievel".taint
      escape_once(evil_str).should_not be_tainted
      escape_once_without_untaint(evil_str).should be_tainted
    end
  end     
  
end