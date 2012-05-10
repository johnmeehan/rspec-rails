require "spec_helper"

module RSpec::Rails
  describe MailerExampleGroup do
    module ::Rails; end
    before do
      Rails.stub_chain(:application, :routes, :url_helpers).and_return(Rails)
      Rails.stub_chain(:configuration, :action_mailer, :default_url_options).and_return({})
    end

    it { should be_included_in_files_in('./spec/mailers/') }
    it { should be_included_in_files_in('.\\spec\\mailers\\') }

    it "adds :type => :mailer to the metadata" do
      group = RSpec::Core::ExampleGroup.describe do
        include MailerExampleGroup
      end
      group.metadata[:type].should eq(:mailer)
    end

    describe "custom application" do
      before do
        @orig_application = RSpec.configuration.application
        RSpec.configuration.application = RSpec::EngineExample
      end

      after do
        RSpec.configuration.application = @orig_application
      end

      it "should include custom application's url helpers" do
        group = RSpec::Core::ExampleGroup.describe do
          include MailerExampleGroup
        end

        example = group.new
        example.bars_path.should == '/bars'
      end
    end
  end
end
