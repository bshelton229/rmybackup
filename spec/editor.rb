$:.unshift File.expand_path('../../lib',__FILE__)
require 'rmybackup'

describe RMyBackup, "#editor" do
  it "should return the editor set in ENV" do
    ENV['EDITOR'] = "/usr/local/bin/mate"
    RMyBackup.editor.should == "/usr/local/bin/mate"
  end
end
