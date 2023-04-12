# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake invoika:db:seed_countries RAILS_ENV=XXX

namespace :invoika do
  namespace :db do
    desc "Seeds countries"
    task seed_countries: :environment do
      CSV.foreach("#{Rails.root}/db/data/countries.csv", headers: true) do |row|
        begin
          ::Country.unscope(where: :is_active).safe_find_or_create_by(iso2: row["iso2"]) do |country|
            country.name = row["name"]
            country.is_active = true
            puts "Country --> [#{row["name"]}] is added successfully."
          end
        rescue Exception => e
          raise "Country --> [#{row["name"]}] is aborted due to internal errors!"
        end
      end
    end
  end
end
