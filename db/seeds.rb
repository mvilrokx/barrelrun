# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)


# db/seeds.rb
require 'open-uri'

available_levels = {"Free" => 0.00, "Bronze" => 199.00, "Silver" => 399.00, "Gold" => 699.00}

RegistrationLevel.delete_all
available_levels.each do |level, price|
  puts price
  RegistrationLevel.find_or_create_by_name(:name => level, :price => price)
end

STDOUT.sync = true

wineryFiles = ["db/ListofWineries_AtoG_NapaRegion.txt", "db/ListofWineries_temeculaValley.txt", "db/ListofWineries_CentraltoSouth_CA.txt"]
#wineryFiles = ["db/ListofWineries_CentraltoSouth_CA.txt"]
wineFiles = ["db/ListofWines_AtoG_NapaRegion.txt", "db/ListofWines_temeculaValley.txt", "db/ListofWines_CentraltoSouth_CA.txt"]
#wineFiles = ["db/ListofWines_CentraltoSouth_CA.txt"]

#Winery.delete_all
idx = Winery.maximum("id")||1

wineryFiles.each do |wineryFile|
  open(wineryFile) do |wineries|
    print "\nLoading Wineries from file " + wineryFile
    wineries.read.each_line do |winery|
      winery_name, address, city, state, zipcode, telephone, website = winery.chomp.strip.split("|")
      idx = idx + 1

      if website.blank? then
        website = "www.barrelrun.com"
      end
      if telephone.blank? then
        telephone = "555.555.5555"
      end
      begin
        winery = Winery.find_or_initialize_by_winery_name(:winery_name => winery_name,
#        winery = Winery.find_or_create_by_winery_name(:winery_name => winery_name,
                       :address => address,
                       :city => city,
                       :state => state,
                       :zipcode => zipcode,
                       :country => "USA",
                       :telephone => telephone,
                       :website_url => "http://" + website,
                       :username => winery_name,
                       :email => "changeme" + idx.to_s + "@example.com",
                       :contact_first_name => "change me",
                       :contact_last_name => "change me",
                       :password => "s3cr3t sauce",
                       :confirm_password => "s3cr3t sauce"
                       )
        winery.seed_data = true
        winery.save!
        print "."
      rescue Exception => e
        if winery_name != "winery name" && address != "address" && city != "city" && zipcode != "zipcode"
          puts "\nERROR WITH " + winery_name + ' ERROR = ' + e.message
#          puts e.message
        else
          puts "\nWarning: Please remove the column headers/titles from your file"
        end
      end
    end
  end
end
puts " "

#Wine.delete_all
#open("db/ListofWines_AtoG_NapaRegion.txt") do |wines|
#open("db/ListofWines_temeculaValley.txt") do |wines|

wineFiles.each do |wineFile|
  open(wineFile) do |wines|

    print "\nLoading Wines from file " + wineFile
    wines.read.each_line do |wine|
      winery_name, wine_name, price, type, vintage, varietal = wine.chomp.strip.split("|")
      if !winery_name.blank? then
        @winery = Winery.find_by_winery_name(winery_name)
        puts "\nLoading wines for winery " + winery_name
      end
      if !wine_name.nil? then
        if !price.blank? then
          price.slice!(0)
        end
        begin
          Wine.find_or_create_by_name_and_winery_id(:name => wine_name,
                                :winery_id => @winery.id,
                                :price => price,
                                :wine_type => type,
                                :vintage => vintage,
                                :varietal => varietal)
          print "."
        rescue Exception => e
          if winery_name != "winery name" && wine_name != "name" && price != "pricy" && type != "type"
            puts "\nERROR WITH WINE " + wine_name + " ERROR = " + e.message
            puts "   price = " + price
            puts "   type = " + type
            puts "   vintage = " + vintage
            puts "   varietal = " + varietal
          else
            puts "\nWarning: Please remove the column headers/titles from your file"
          end
        end
      end
    end
  end
end
puts " "

