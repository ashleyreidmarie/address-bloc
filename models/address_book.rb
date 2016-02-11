require_relative 'entry'

class AddressBook
  attr_reader :entries
  
  def initialize
    @entries = []
  end
  
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
  
end