$:.unshift File.expand_path('../../lib',__FILE__)
require 'rmybackup'

describe RMyBackup, "#test" do
  it "should return the editor set in env" do
    ENV['EDITOR'] = "/usr/local/bin/mate"
    RMyBackup.editor.should == "/usr/local/bin/mate"
    puts RMyBackup.editor
  end
end
