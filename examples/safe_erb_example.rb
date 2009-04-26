require File.expand_path(File.join(File.dirname(__FILE__), "example_helper.rb"))

describe "Safe ERB" do
    
  describe "ERB" do
  
    describe "Util" do      
      it "html_escape renders an untainted string" do
        src = "<script>alert('hi');</script>"
        out = ERB::Util.html_escape(src)
        out.should == "&lt;script&gt;alert('hi');&lt;/script&gt;"
        out.should_not be_tainted
      end      
    end
  
  end

  describe "ActionView::Helpers::SanitizeHelper" do
    pending "strip_tags_with_untaint renders an untainted string" do
      src = "<script>alert('hi');</script>"
      out = ActionView::Helpers::SanitizeHelper.strip_tags_with_untaint(src)
      out.should == "&lt;script&gt;alert('hi');&lt;/script&gt;"
      out.should_not be_tainted      
    end    
  end

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