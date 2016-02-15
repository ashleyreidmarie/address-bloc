require_relative 'entry'
require "csv"

class AddressBook
  attr_reader :entries
  
  def initialize
    @entries = []
  end
  
  #adds entry in lexographical order as a new Entry
  def add_entry(name, phone_number, email)
    index = 0
    @entries.each do |entry|
      if name < entry.name
        break
      end
      index += 1
    end
    
    @entries.insert(index, Entry.new(name, phone_number, email))
  end
  
  #removes all entries that match the name, phone number, and email in the entries array
  def remove_entry(name, phone_number, email)
    @entries.each do |entry|
      if name == entry.name && 
        phone_number == entry.phone_number &&
        email == entry.email
        @entries.delete(entry)
      end
    end
  end
  
  def entries_range
    if @entries.count > 1
      "(1 - #{@entries.count})"
    else
      "(#{@entries.count})"
    end
  end
  
  def import_from_csv(file_name)
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    
    csv.each do |row|
      row_hash = row.to_hash
      add_entry(row_hash["name"], row_hash["phone_number"], row_hash["email"])
    end
  end
end