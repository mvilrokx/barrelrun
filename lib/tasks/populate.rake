# lib/tasks/populate.rake
namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    
    # [Wine].each(&:delete_all)
    # [Event].each(&:delete_all)
    # [Special].each(&:delete_all)
    
    Wine.populate 20 do |wine|
      wine.name = Populator.words(1..3).titleize
      wine.winery_id = 2
      wine.description = Populator.sentences(2..6)
      wine.price = [4.99, 19.95, 100]
      wine.type = ["red", "white", "rose", "Sparkling & Champagne"]
      wine.vintage = ["1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009"]
      wine.varietal = ["Pinot", "Cabarnet", "Merlot", "Chardonnay", "Viognier"]
      wine.created_at = 2.years.ago..Time.now
      wine.updated_at = wine.created_at
    end
    
    Event.populate 20 do |event|
      event.title = Populator.words(1..3).titleize
      event.winery_id = 2
      event.description = Populator.sentences(1..4)
      event.place = ["Napa", "Temecula", "Sonoma"]
      event.start_date = Time.now
      event.end_date = Time.now.next_month..Time.now.next_year
      event.created_at = 2.years.ago..Time.now
      event.updated_at = event.created_at
    end

    Special.populate 20 do |special|
      special.title = Populator.words(1..3).titleize
      special.winery_id = 2
      special.description = Populator.sentences(1..4)
      special.start_date = Time.now
      special.end_date = Time.now.next_month..Time.now.next_year
      special.created_at = 2.years.ago..Time.now
      special.updated_at = special.created_at
    end

    Award.populate 20 do |award|
      award.title = Populator.words(1..3).titleize
      award.winery_id = 2
      award.description = Populator.sentences(1..4)
      award.created_at = 2.years.ago..Time.now
      award.updated_at = award.created_at
    end

  end
end
