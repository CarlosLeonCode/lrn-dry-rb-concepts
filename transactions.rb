# frozen_string_literal: true

require 'ruby_jard'
require "dry/transaction"

class AskError < StandardError; end

class MakeLunch
  include Dry::Transaction

  step :buy_ingredients
  map :clean_kitchen
  try :ask_for_chef_help, catch: AskError
  step :cook_rice
  tee :play_some_music
  step :make_chicken
  step :make_soup
  map :make_some_drink
  tee :call_to_mom
  check :lunch
  step :serve_lunch
  tee :flow_logs

  def buy_ingredients
    p '--' * 6
    p "😎 Buy ingredients"
    puts
    Success({ingredients: true})
  end

  def clean_kitchen(input)
    p '-_-_-_' * 6
    p "😁 Cleaning Kitchen #{input}"
    puts
    input
  end

  def ask_for_chef_help(input)
    p '--' * 6
    p "🧐 Chef help #{input}"
    puts
    if rand_number == 0
      input[:chef_help] = false
      puts '-> Chef cannot help, try it again!'
      Failure(raise AskError.new)
    else
      input[:chef_help] = true
      Success(input)
    end
  end

  def cook_rice(input)
    input = input.value_or
    p '--' * 6
    p "🍚 Cook rice #{input}"
    puts

    input[:cooked_rice] = rand_number == 1 ? true : false
    Success(input)
  end

  def play_some_music(input)
    p '-o-' * 6
    p "🎼 Playing music...."
    puts
  end

  def make_chicken(input)
    p '--' * 6
    p "🍗 Cook rice #{input}"
    puts

    input[:make_chicken] = rand_number == 1 ? true : false
    Success(input)
  end

  def make_soup(input)
    p '--' * 6
    p "🫕 Make soup #{input}"
    puts

    input[:make_soup] = rand_number == 1 ? true : false
    Success(input)
  end

  def make_some_drink(input)
    p '--' * 6
    p "🍺 Make something to drink #{input}"
    puts

    input[:some_drink] = rand_number == 1 ? 'Juice' : 'Beer'
    input
  end

  def call_to_mom(input)
    p '--' * 6
    p "📱 Call to mom #{input}"
    puts
  end

  def lunch(input)
    p '--' * 6
    p "🧐 Checking lunch #{input}"
    puts

    input[:make_soup] && input[:make_chicken] && input[:cooked_rice]
  end

  def serve_lunch(input)
    p '--' * 6
    p "🌟🍽  Serve Lunch 🙌🙌"
    puts

    input[:lunch] = 'Done!!!'
    Success(input)
  end

  def flow_logs(input)
    puts
    p "Logs!"
    p '--' * 6
    input.each do |key, val|
      puts "#{key} => #{val}"
    end
    p '--' * 6
  end

  private

  def rand_number
    @rand_number ||= rand(0..1)
  end
end

MakeLunch.new.call()
