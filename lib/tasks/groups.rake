namespace :groups do
  desc "Cleanup the custom groups and group connection after every tournament"
  task :cleanup => :environment do
    CustomGroup.all.each(&:destroy)
  end
end
