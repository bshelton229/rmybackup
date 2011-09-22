$:.unshift File.expand_path('../../lib',__FILE__)
require 'rmybackup'

# $BUNDLE_GEMFILE can set the gemfile to set up a better test

describe "We should be able to get databases" do
  it "should return mysql or mysql2" do
    get_databases_via = RMyBackup::Base.get_databases_via
    get_databases_via.should match /^(mysql|mysql2)$/
  end
end
