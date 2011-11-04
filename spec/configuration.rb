require File.expand_path('../spec_helper',__FILE__)

describe "We should be able to load a config file" do
  it "should return mysql or mysql2" do
    config = RMyBackup::Configuration.load File.expand_path('../config.yml', __FILE__ )
    File.basename(config.file).should == "config.yml"
  end
end
