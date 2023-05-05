# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake invoika:db:seed_cities RAILS_ENV=XXX

namespace :invoika do
  namespace :db do
    desc "Seeds states"
    task seed_cities: :environment do
      CSV.foreach("#{Rails.root}/db/data/cities.csv", headers: true) do |row|
        begin
          country = ::Country.unscope(where: :is_active).find_by(name: row["country"])
          state = country.states.unscope(where: :is_active).find_by(name: row["state"])
          state.cities.unscope(where: :is_active).safe_find_or_create_by(name: row["name"]) do |city|
            city.is_active = true
            city.country = country
            puts "City --> [#{row["name"]}] is added successfully."
          end
        rescue Exception => e
          raise "City --> [#{row["name"]}] is aborted due to internal errors!"
        end
      end
    end
  end
end
