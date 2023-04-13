# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake invoika:db:seed_states RAILS_ENV=XXX

namespace :invoika do
  namespace :db do
    desc "Seeds states"
    task seed_states: :environment do
      CSV.foreach("#{Rails.root}/db/data/states.csv", headers: true) do |row|
        begin
          country = ::Country.unscope(where: :is_active).find_by(name: row["country"])
          country.states.unscope(where: :is_active).safe_find_or_create_by(name: row["name"]) do |state|
            state.is_active = true
            puts "State --> [#{row["name"]}] is added successfully."
          end
        rescue Exception => e
          raise "State --> [#{row["name"]}] is aborted due to internal errors!"
        end
      end
    end
  end
end
