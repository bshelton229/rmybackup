require File.expand_path('../spec_helper',__FILE__)

describe RMyBackup, "#editor" do
  it "should return the editor set in ENV" do
    ENV['EDITOR'] = "/usr/local/bin/mate"
    RMyBackup::Base.editor.should == "/usr/local/bin/mate"
  end
end
