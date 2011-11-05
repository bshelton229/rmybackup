require File.expand_path('../spec_helper',__FILE__)

describe "After we load the configuration file" do
  config = RMyBackup::Configuration.load File.expand_path('../templates/config.yml', __FILE__ )
  it "Should load a file specified in .load" do
    File.basename(config.file).should == "config.yml"
  end

  it "Config should hold some base attributes" do
    config.host.should == "localhost"
    config.password.should == "password"
    config.username.should == "root"
    config.bin[:mysqldump].should == "mysqldump"
  end
end
