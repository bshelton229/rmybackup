require File.expand_path('../spec_helper',__FILE__)

describe "After we load the configuration file" do
  config = RMyBackup::Configuration.load File.expand_path('../templates/config.yml', __FILE__ )
  it "It should show the file we loaded as" do
    File.basename(config.file).should == "config.yml"
  end
end
