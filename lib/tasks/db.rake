# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake invoika:db:seed RAILS_ENV=XXX

require "csv"

namespace :invoika do
  namespace :db do
    desc "Seeds the database with default data"
    task seed: :environment do
      begin
        Rake::Task["invoika:db:seed_countries"].invoke
        Rake::Task["invoika:db:seed_states"].invoke
        Rake::Task["invoika:db:seed_cities"].invoke
      rescue Exception => e
        raise "Database seeding is aborted due to internal errors!"
      end
    end
  end
end
