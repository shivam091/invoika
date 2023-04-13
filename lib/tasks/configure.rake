# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake invoika:configure RAILS_ENV=XXX
# rake invoika:unconfigure! RAILS_ENV=XXX

require File.dirname(__FILE__) + "/rake_helper.rb"

namespace :invoika do

  desc "Configure Invoika on new system"
  task configure: :environment do
    answer = prompt("You are about to configure the Invoika in #{Rails.env} " \
      "environment. Do you want to proceed? (Yn): ", %w{Y n})
    if answer == "Y"
      puts "↳ -------------------------------> Installing Invoika"
      begin
        sh "bundle install"
        Rake::Task["tmp:create"].invoke
        Rake::Task["db:create"].invoke
        Rake::Task["db:migrate"].invoke
        Rake::Task["db:seed"].invoke
        Rake::Task["invoika:db:seed"].invoke
        Rake::Task["assets:precompile"].invoke
        sh "rspec"
        puts "↳ ----------------------------> Installation completed"
      rescue Exception => e
        raise "Installation aborted due to internal errors!"
      end
    else
      puts "Installation cancelled."
    end
  end

  desc "Unconfigure Invoika from the system"
  task unconfigure!: :environment do
    Kernel.warn ERB.new(<<~EOS).result
      ******************************************************************************
      ******************************************************************************
                ██     ██  █████  ██████  ███    ██ ██ ███    ██  ██████ 
                ██     ██ ██   ██ ██   ██ ████   ██ ██ ████   ██ ██      
                ██  █  ██ ███████ ██████  ██ ██  ██ ██ ██ ██  ██ ██   ███ 
                ██ ███ ██ ██   ██ ██   ██ ██  ██ ██ ██ ██  ██ ██ ██    ██ 
                 ███ ███  ██   ██ ██   ██ ██   ████ ██ ██   ████  ██████  
      ******************************************************************************
      ******************************************************************************
    EOS
    answer = prompt("You are about to unconfigure the Invoika in " \
      "#{Rails.env} environment. This action can not be UNDONE. Do you still " \
      "want to proceed? (Yn): ", %w{Y n})
    if answer == "Y"
      puts "↳ -----------------------------> Uninstalling Invoika"
      begin
        Rake::Task["assets:clobber"].invoke
        Rake::Task["db:drop"].invoke
        Rake::Task["log:clear"].invoke
        Rake::Task["tmp:clear"].invoke
        puts "↳ --------------------------> Uninstallation completed"
      rescue Exception => e
        raise "Uninstallation aborted due to internal errors!"
      end
    else
      puts "Uninstallation cancelled."
    end
  end
end
